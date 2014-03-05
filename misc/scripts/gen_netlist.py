#! /usr/bin/env python
# -*- coding: utf-8 -*-

"""Generate netlist

Usage:
  gen_netlist.py [options]
  gen_netlist.py (-h | --help)
  gen_netlist.py --version

Options:
  --root-cnt=<int>      Amount of root switches [default: 1]
  --leave-cnt=<int>     Amount of leave switches [default: 2]
  --node-cnt=<int>      Amount of terminals [default: 4]
  --root-ports=<int>    Amount of root ports [default: 5]
  --leave-ports=<int>   Amount of leave ports [default: 5]
  --draw                Draw graph instead of dumping netlist
  -h --help             Show this screen.
  --version             Show version.
"""

# load librarys
import sys
from docopt import docopt
import networkx as nx
import matplotlib.pyplot as plt


class MyGraph(object):
    """
    Class to hold the functioanlity of the script
    """

    def __init__(self, opt):
        """
        Init of instance
        """
        self.opt = opt
        self.sw_template = "sw%(sw_id)s"
        self.node_template = 'node%(sw_id)s%(port_id)s'
        self.graph = nx.Graph()

    def add_switch(self, sw_id, ports=48):
        """ adds a switch to the graph
        """
        name = self.sw_template % {'sw_id': sw_id}
        self.graph.add_node(name, ports=ports, type='switch')

    def add_node(self, node, ports=1, switch=None):
        """ adds a node to the graph
        """
        self.graph.add_node(node, ports=ports, type='node')
        if switch in self.graph.nodes():
            src_port = self.get_free_switch_port(switch)
            self.graph.add_edge(switch, node,
                            src_name=switch, src_port=src_port,
                            dst_name=node, dst_port=1)

    def get_free_switch_port(self, switch):
        """ collects all used ports and gets a free one
        """
        max_ports = self.graph.node[switch]['ports']
        used_ports = set([])
        for edge in self.graph.edges(switch, data=True):
            (src_name, dest_name, data) = edge
            if switch == src_name:
                used_ports.add(int(data['src_port']))
            elif switch == dest_name:
                used_ports.add(int(data['dst_port']))
        if len(used_ports) == 0:
            return 1
        elif len(used_ports) < max_ports:
            return list(used_ports)[-1] + 1
        else:
            raise ValueError("Switch exceeds port-range")

    def add_leave_switch(self, sw_id, ports=48, node_template=None, sw_template=None):
        """ adds a switch and the nodes for the switch
        """
        if sw_template is None:
            sw_template = self.sw_template
        if node_template is None:
            node_template = self.node_template
        sw_name = sw_template % {'sw_id': sw_id}
        self.add_switch(sw_id, ports)
        swid = str(sw_id).rjust(3,"0")
        for port_id in range(1, ports):
            portid = str(port_id).rjust(3,"0")
            node_name = node_template % {'sw_id': swid, 'port_id': portid}
            self.add_node(node_name, switch=sw_name)

    def connect_switches(self, src_id, dest_id):
        """ connect two switches
        """
        src_name = self.sw_template % {'sw_id': src_id}
        dest_name = self.sw_template % {'sw_id': dest_id}
        assert src_name in self.graph.nodes()
        assert dest_name in self.graph.nodes()
        src_port = self.get_free_switch_port(src_name)
        dst_port = self.get_free_switch_port(dest_name)
        print "connect %s[%s]--[%s]%s" % (src_name, src_port, dst_port, dest_name)
        self.graph.add_edge(src_name, dest_name,
                            src_name=src_name, src_port=src_port,
                            dst_name=dest_name, dst_port=dst_port)

    def draw(self):
        """ draw the graph
        """
        nx.draw(self.graph)
        plt.show()

    def dump_netlist(self):
        """ creates netlist
        """
        lines = []
        for node in self.graph.nodes(data=True):
            (name, data) = node
            if data['type'] == "switch":
                lines.extend(self.dump_switch_lines(node))
            else:
                lines.extend(self.dump_node_lines(node))
        with open('test.netlist', 'w') as fd:
            fd.write("\n".join(lines))

    def dump_switch_lines(self, node):
        """ Create netlist section for switch

        Switch <ports> "<name>"
        [sw_port]     "<dest_name>"[dst_port]
        """
        (name, data) = node
        data['name'] = name
        lines = [
            "Switch %(ports)s \"%(name)s\"" % data
        ]
        connections = {}
        for edge in self.graph.edges(name, data=True):
            (src_port, line) = self.create_connection_line(edge)
            connections[int(src_port)] = line
        for src_port in sorted(connections.keys()):
            lines.append(connections[src_port])
        lines.append("")
        return lines

    def dump_node_lines(self, node):
        """ Create netlist section for node

        Hca     <ports> "<node_name>"
        [<node_port>]     "<dst_name>"[<dst_port>]
        """
        (name, data) = node
        data['name'] = name
        lines = [
            "Hca %(ports)s \"%(name)s\"" % data
        ]
        for edge in self.graph.edges(name, data=True):
            (_, line) = self.create_connection_line(edge)
            lines.append(line)
        lines.append("")
        return lines


    @staticmethod
    def create_connection_line(edge):
        """ consumes edge and returns (source_port, swich_connection line)

        IN: ('sw2', 'sw1', {'src_name': 'sw1', 'src_port': 1, 'dst_name': 'sw2', 'dst_port': 5})
        OUT: (5, '[5]    "sw1"[1]')
        """
        (src_name, dst_name, data) = edge
        if src_name == data['src_name']:
            src_p = data['src_port']
            dst_p = data['dst_port']
        elif src_name == data['dst_name']:
            src_p = data['dst_port']
            dst_p = data['src_port']
        src_port_str = "[%s]" % src_p
        dst_port_str = "[%s]" % dst_p
        line = "%-10s \"%s\"%s" % (src_port_str, dst_name, dst_port_str)
        return (int(src_p), line)



def main():
    """ main function """
    options = docopt(__doc__,  version='0.1')
    mg = MyGraph(options)
    root_ids = range(1, int(options.get('--root-cnt')) + 1)
    leave_ids = range(root_ids[-1] + 1, root_ids[-1] + int(options.get('--leave-cnt')) + 1)
    node_ids = range(1, int(options.get('--node-cnt')))
    for root_id in root_ids:
        mg.add_switch(root_id, ports=int(options.get('--root-ports')))
    for leave_id in leave_ids:
        mg.add_leave_switch(leave_id, ports=int(options.get('--leave-ports')))
        for root_id in root_ids:
            mg.connect_switches(root_id, leave_id)
    if options.get('--draw'):
        mg.draw()
    else:
        mg.dump_netlist()


    

if __name__ == "__main__":
    main()
