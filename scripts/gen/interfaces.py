import os
import secrets
import string
from jinja2 import Environment, FileSystemLoader
import urllib.parse
import socket

INTERFACES_TEMPLATE = "onpre/scripts/interfaces/interfaces.j2"
VPN_DOMAIN = "magic.halcyon.cloud.shiron.dev"
HOSTNAME_LIST = {
    1: "souzou08",
    2: "souzou03",
    3: "souzou04",
    4: "souzou05",
}

script_path = os.path.dirname(os.path.abspath(__file__))
path = os.path.abspath(os.path.join(script_path, "../../"))

file_loader = FileSystemLoader(path)
env = Environment(loader=file_loader)


def gen_interfaces():
    template = env.get_template(INTERFACES_TEMPLATE)

    vpn_server_ip = socket.gethostbyname(VPN_DOMAIN)
    data = {}
    for i in range(1, 4 + 1):
        data[f"pve0{i}"] = {
            "hostname": HOSTNAME_LIST[i],
            "pve_name": f"pve0{i}",
            "lan_ip": f"172.16.168.{33+i}",
            "vpn_local_ip": f"192.168.30.3{i}",
            "vpn_server_ip": vpn_server_ip,
        }

    for key in data.keys():
        template.globals["vars"] = data[key]

        output = template.render()
        output_path = os.path.join(path, "onpre/scripts/interfaces", key)

        if os.path.exists(output_path):
            print(f"{output_path} already exists.")
            print("Do you want to overwrite it? [y/N]: ", end="")
            answer = input().lower()
            if answer != "y":
                print("Skip.")
                continue

        with open(output_path, "w") as f:
            f.write(output)
