# -*- coding: utf-8 -*-

import re

class _RunMe(object):
    def __init__(self, commands_file, layout_file):
        self.commands_file = commands_file
        self.layout_file = layout_file
        self.commands = {}
        self.output = []
        self.looparray = ""
        self.loopitem = ""
        self.ifcommand = ""
        self.ifvalue = ""

    def commands_load(self):
        with open(self.commands_file) as fp:
            for line in fp:
                # remove EOL
                line = line.rstrip()
                # variable: string
                if re.match("^\"\w+\": \".*\"$", line):
                    param = re.search("^\"(\w+)\": \"(.*)\"$", line)
                    # add key => value (string)
                    self.commands[param.group(1)] = param.group(2)
                # variable: array
                elif re.match("^\"\w+\": \[.*\]$", line):
                    param = re.search("^\"(\w+)\": \[(.*)\]$", line)
                    varray = param.group(2).split(',')
                    newarray = []
                    for v in varray:
                        value = re.search("\"(.*)\"",v)
                        newarray.append(value.group(1))
                    # add key => value (array)
                    self.commands[param.group(1)] = newarray
                # unknown
                else:
                    raise Exception(
                        'Wrong input file format {}'.format(line)
                    )

    def layout_load(self):
        with open(self.layout_file) as fp:
            for line in fp:
                # remove EOL
                line = line.rstrip()
                # if end of 'if', 'if' cleanup, go to next line
                if re.match("{{/if}}",line):
                    self.ifcommand = ""
                    self.ifvalue = ""
                    continue
                # if end of 'loop', 'loop' cleanup, go to next line
                if re.match("{{/loop}}",line):
                    self.looparray = ""
                    self.loopitem = ""
                    continue
                # searching for a command:
                # group(1) - before the command
                # group(2) - the command
                # group(3) - after the command
                mylayout = re.search("^(.*){{(.*)}}(.*)$", line)
                if mylayout:
                    layoutif = re.search("^#if (\w+) (.*)$", mylayout.group(2))
                    # the command is 'if', 'if' setup, go to the next line
                    if layoutif:
                       self.ifcommand = layoutif.group(1)
                       self.ifvalue = layoutif.group(2)
                       continue
                    layoutloop = re.search("^#loop (\w+) (\w+)$", mylayout.group(2))
                    # the command is 'loop', 'loop' setup, go to the next line
                    if layoutloop:
                        self.looparray = layoutloop.group(1)
                        self.loopitem = layoutloop.group(2)
                        continue
                    # print command
                    else:
                        if len(self.looparray):
                            # loop is configured
                            if not len(self.commands[self.looparray]):
                                # this array is not configured, skip the line
                                continue
                            for value in self.commands[self.looparray]:
                                # check for 'if' configuration
                                if not self.ifvalue or (self.ifvalue == value):
                                    # add the line to the output
                                    self.output.append("%s%s%s" % (mylayout.group(1), value, mylayout.group(3)))
                        else:
                            # no loop, check for 'if' configuration, print command
                            if not self.ifcommand or (self.ifcommand == mylayout.group(2) and self.ifvalue == self.commands[mylayout.group(2)]):
                                # add the line to the output
                                self.output.append("%s%s%s" % (mylayout.group(1), self.commands[mylayout.group(2)], mylayout.group(3)))
                # no 'command', no 'loop', no 'if', add the line to the output
                else:
                   self.output.append(line)

    def __call__(self):
        # parse commands from file
        self.commands_load()
        # parse layout from file
        self.layout_load()
        # return the output array
        return self.output

def runme(commands_file, layout_file):
    loadte = _RunMe(commands_file, layout_file)
    return loadte()
