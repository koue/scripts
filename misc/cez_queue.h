/*
** Copyright (c) 2018 Nikola Kolev <koue@chaosophia.net>
**
** This program is free software; you can redistribute it and/or
** modify it under the terms of the Simplified BSD License (also
** known as the "2-Clause License" or "FreeBSD License".)

** This program is distributed in the hope that it will be useful,
** but without any warranty; without even the implied warranty of
** merchantability or fitness for a particular purpose.
**
*******************************************************************************
*/

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/queue.h>

#ifndef _CEZ_QUEUE_H
#define _CEZ_QUEUE_H

struct queue_param {
        TAILQ_ENTRY(queue_param) queue_entry;
        char *name;
        char *value;
};

#define Q_INIT(current_head) TAILQ_HEAD(current_head, queue_param) \
    current_head = TAILQ_HEAD_INITIALIZER(current_head);

#define Q_ADD(current_head, current_name, current_value) do {\
	struct queue_param *current;\
	if ((current = calloc(1, sizeof(*current))) == NULL) {\
		fprintf(stderr, "[Error] %s: %s\n", __func__, strerror(errno));\
		exit(1);\
	}\
	current->name = strdup((current_name));\
	if (current->name == NULL) {\
		free(current);\
		fprintf(stderr, "[ERROR] %s: %s\n", __func__, strerror(errno));\
		exit(1);\
	}\
	current->value = strdup((current_value));\
	if (current->value == NULL) {\
		free(current->name);\
		free(current);\
		fprintf(stderr, "[ERROR] %s: %s\n", __func__, strerror(errno));\
		exit(1);\
	}\
	TAILQ_INSERT_TAIL(current_head, current, queue_entry);\
} while (0)

#define Q_PRINT(current_head) do {\
	struct queue_param *current;\
	TAILQ_FOREACH(current, current_head, queue_entry) {\
		printf("name=%s, value=%s\n", current->name, current->value);\
	}\
} while (0)

#define Q_PURGE(current_head) do {\
	struct queue_param *current;\
	while (!TAILQ_EMPTY(current_head)) {\
		current = TAILQ_FIRST(current_head);\
		free(current->name);\
		free(current->value);\
		TAILQ_REMOVE(current_head, current, queue_entry);\
		free(current);\
	}\
} while (0)

#endif
