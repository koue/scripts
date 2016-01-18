/*
 * Copyright (c) 2002-2010, Daniel Hartmeier
 * Copyright (c) 2013-2014, Nikola Kolev
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *    - Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer. 
 *    - Redistributions in binary form must reproduce the above
 *      copyright notice, this list of conditions and the following
 *      disclaimer in the documentation and/or other materials provided
 *      with the distribution. 
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <net/if.h>
#include <arpa/inet.h>
#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <libxml/tree.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

#include "data.h"
#include "graph.h"

extern int	parse_config(const char *, struct matrix **);


struct gpx_point {
	double lat, lon;
	double ele;
//	bool valid;
	struct tm time;
};

struct col {
	unsigned	nr;
	char		arg[128];
	int 		diff;
	double		val;
} cols[64];

unsigned maxcol = 0;
unsigned since = 0;
int debug = 0;

static void
usage(void)
{
	extern char *__progname;

	fprintf(stderr, "usage: %s [-v] [-c config] [-f file]\n", __progname);
	exit(1);
}

xmlXPathContextPtr xmlXPathNewContextNode(xmlDocPtr doc, xmlNodePtr node) {
	xmlXPathContextPtr retval = xmlXPathNewContext(doc);
	xmlXPathRegisterNs(retval, (xmlChar*)"gpx", (xmlChar*)"http://www.topografix.com/GPX/1/0");
	retval->node = node;
	return retval;
}

int
add_col (unsigned nr, const char *arg, int diff)
{
	int i;
	
	for ( i = 0; i < maxcol; i++) {
		if (cols[i].nr == nr) {
			fprintf(stderr, "add_col: %d already defined\n", nr);
			return (-1);
		}
	}
	if (maxcol == sizeof(cols) / sizeof(cols[0])) {
		fprintf(stderr, "add_col: limit of %d collects reached\n", maxcol);
		return (-1);
	}
	cols[maxcol].nr = nr;
	strlcpy(cols[maxcol].arg, arg, sizeof(cols[maxcol].arg));
	cols[maxcol].diff = diff;
	maxcol++;
	return (0);
}

int
main(int argc, char *argv[])
{
	const char *configfn = "/etc/gpsgraph.conf";
	const char *datafn = "/tmp/gpsgraph.db";
	const char *gpxfile = NULL;
	int ch, query = 0, draw = 0, trunc = 0, i;
	struct matrix *matrices = NULL, *m;
	struct graph *g;
	struct gpx_point curPt = {0};

	while ((ch = getopt(argc, argv, "c:f:v")) != -1) {
		switch (ch) {
		case 'c':
			configfn = optarg;
		case 'f':
			gpxfile = optarg;
			break;
		case 'v':
			debug++;
			break;
		default:
			usage();
		}
	}
	if (argc != optind)
		usage();
	if (!gpxfile)
		usage();

	if (parse_config(configfn, &matrices))
		return (1);

	if (data_open(datafn))
		return (1);
/*
	if (query) {

		if (debug)
			printf("querying values\n");

		for (i = 0; i < maxcol; ++i) {
			if (debug)
				printf("set_col(%d, %s, %lf)\n", cols[i].nr, cols[i].arg,  value_query(cols[i].arg));
			set_col(cols[i].nr, value_query(cols[i].arg));
		}

		if (debug)
			printf("storing values in database\n");
		for (i = 0; i < maxcol; ++i)
			if (data_put_value(since, time(NULL), cols[i].nr,
			    cols[i].val, cols[i].diff)) {
				fprintf(stderr, "main: data_put_value() "
				    "failed\n");
				return (1);
			}

	}
*/

	xmlInitParser();

	xmlDocPtr doc = xmlParseFile(gpxfile);

	xmlXPathContextPtr context = xmlXPathNewContext(doc);
	xmlXPathRegisterNs(context, (xmlChar*)"gpx", (xmlChar*)"http://www.topografix.com/GPX/1/0");

	xmlXPathObjectPtr tracks = xmlXPathEvalExpression((xmlChar*)"//gpx:trk/gpx:trkseg", context);
	if(tracks == NULL || xmlXPathNodeSetIsEmpty(tracks->nodesetval)) {
		printf("No track segment found in %s\n", argv[1]);
	}

	xmlNodeSetPtr trackNodes = tracks->nodesetval;

	xmlChar *end = 0;

	for(int t = 0; t < trackNodes->nodeNr; ++t) {
		if(trackNodes->nodeTab[t]->type != XML_ELEMENT_NODE) continue;

		xmlXPathContextPtr ptContext = xmlXPathNewContextNode(doc, trackNodes->nodeTab[t]);
		xmlXPathObjectPtr points = xmlXPathEvalExpression((xmlChar*)"gpx:trkpt", ptContext);

		if (points !=0 && !xmlXPathNodeSetIsEmpty(points->nodesetval)) {
			for (int p = 0; p<points->nodesetval->nodeNr; ++p) {
				xmlNodePtr ptNode = points->nodesetval->nodeTab[p];
				
				if (xmlHasProp(ptNode, (xmlChar*)"lat") && xmlHasProp(ptNode, (xmlChar*)"lon")) {
					xmlChar *lat = xmlGetProp(ptNode, (xmlChar*)"lat");
					curPt.lat = strtod((char*)lat, (char**)&end);
					if ( lat != 0) xmlFree(lat);

					xmlChar *lon = xmlGetProp(ptNode, (xmlChar*)"lon");
					curPt.lon = strtod((char*)lon, (char**)&end);
					if ( lon != 0) xmlFree(lon);
				}

				xmlXPathContextPtr eleContext = xmlXPathNewContextNode(doc, ptNode);
				xmlXPathObjectPtr elevation = xmlXPathEvalExpression((xmlChar*)"gpx:ele/text()", eleContext);
				if (elevation != 0) {
					xmlChar *eVal = elevation->nodesetval->nodeTab[0]->content;
					curPt.ele = strtod((char*)eVal, (char**)&end);
				}
			//	printf("%.2f\n", curPt.ele);
				if (elevation) xmlXPathFreeObject(elevation);
				xmlXPathFreeContext(eleContext);

				//time
				xmlXPathContextPtr timeContext = xmlXPathNewContextNode(doc, ptNode);
				xmlXPathObjectPtr time = xmlXPathEvalExpression((xmlChar*)"gpx:time/text()", timeContext);
				if (time != 0) {
					xmlChar *tVal = time->nodesetval->nodeTab[0]->content;
					strptime((char*)tVal, "%Y-%m-%dT%H:%M:%SZ", &(curPt.time));
				}
				if (time) xmlXPathFreeObject(time);
				xmlXPathFreeContext(timeContext);
				//printf("%lu\n", mktime(&curPt.time));
				// data
				data_put_value(since, mktime(&curPt.time), 1, curPt.ele, 0);
				
			}
		}
		if (points) xmlXPathFreeObject(points);
		xmlXPathFreeContext(ptContext);
	}	
	if (tracks) xmlXPathFreeObject(tracks);
	xmlXPathFreeContext(context);
	
	xmlFreeDoc(doc);
	xmlCleanupParser();

	draw = 1;

	if (draw) {

		if (debug)
			printf("generating images\n");
		for (m = matrices; m != NULL; m = m->next)
			for (i = 0; i < 2; ++i)
				for (g = m->graphs[i]; g != NULL; g = g->next) {
					if (debug)
						printf("fetching values for "
						    "unit %u from database\n",
						    g->desc_nr);
					if (data_get_values(g->desc_nr, m->beg,
					    m->end, g->type, m->w0, g->data)) {
						fprintf(stderr, "main: "
						    "data_get_values() "
						    "failed\n");
						return (1);
					}
				}
		if (debug)
			printf("drawing and writing images\n");
		if (graph_generate_images(matrices)) {
			fprintf(stderr, "main: graph_generate_images() "
			    "failed\n");
			return (1);
		}

	}

	data_close();

	unlink(datafn);

	return (0);
}
