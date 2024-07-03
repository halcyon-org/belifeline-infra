#! /usr/bin/python3
# -*- coding: utf-8 -*-
#
# An encrypted password can be decrypted as follows;
# $ openssl rsautl -raw -decrypt -inkey id_rsa -in pw.txt

import subprocess
import urllib.request
import re
from html.parser import HTMLParser
import getpass
import sys
import time
import os

import pprint

#URL = "http://www.suzuka-ct.ac.jp"
URL = "http://10.10.10.10/login"
POSTURL = "http://10.10.10.10/hello"
PINGHOST = "172.16.200.1"


# string in result html
SUCCESS = "You are logged into the network"
FAILED = "Failed"
EXPIRED = "Expired"
OBSCURE = "Obscure"

#
# HTML Parser
#
class MyHTMLParser(HTMLParser):
    def __init__(self):
        super(self.__class__, self).__init__()
        self.attrs = False
        self.tag = False
        self.data = False

    def handle_starttag(self, tag, attrs):
        self.attrs = attrs

    def handle_endtag(self, tag):
        self.tag = tag

    def handle_data(self, data):
        self.data = data

def printMessage(msg, end='\n'):
    print(msg, file=sys.stderr, end=end)


def ping(host):
    cmd = "ping -c 1 -w 1 " + host
    with subprocess.Popen(cmd.strip().split(" "),
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE
    ) as ping:
        ping.communicate()

        if ping.returncode:
            return False
        else:
            return True

#def readTestFile():
#    with open("f1.html", "r") as file:
#        html = file.readlines()
#    return html

def getForm(url=URL):
    """
    認証ページを取得します。
    3回チャレンジしても取得できないときは、終了します。
    """
    for i in range(3):
        req = urllib.request.Request(url)
        try:
            with urllib.request.urlopen(req) as res:
                html = res.read().decode("utf-8").splitlines(True)
                return html
        except urllib.error.URLError as err:
            printMessage(err.reason)
            time.sleep(1)

    printMessage("cannot open the authentication page. give up.")
    sys.exit(1)


def getTagValue(html):
    for line in html:
        if re.search(TAG, line):
            break

    print(line)
    parser = MyHTMLParser()
    parser.feed(line)

    if not parser.attrs:
        return False

    for attr in parser.attrs:
        if attr[0] == "value":
            return attr[1]

    return False

def getPassword(username):
    # password入力 (^dでキャンセル)
    try:
        msg = "Network authentication password for " + username + " (^d for cancel): "
        password = getpass.getpass(prompt=msg, stream=sys.stderr)
    except EOFError:
        printMessage("canceled.")
        sys.exit()

    return password

def postForm(username, password, url=URL):
    post_data = {
                 "extremenetloginuser": username,
                 "extremenetloginpassword": password
             }

    encoded_post_data = urllib.parse.urlencode(post_data).encode(encoding="ascii")

    with urllib.request.urlopen(url=POSTURL, data=encoded_post_data) as res:
        html = res.read().decode("utf-8").splitlines(True)

    return html

def getResult(html):
    for line in html:
        if re.search(SUCCESS, line):
            return SUCCESS, "OK: Authentication has been completed."
        elif re.search(FAILED, line):
            use_crypto = False
            return FAILED, "ERROR: Username or Password was incorrect."
        elif re.search(EXPIRED, line):
            return EXPIRED, "ERROR: Authentication cache was expired. try again."

    return OBSCURE, "ERROR: Something was wrong."

def main():

    # pingテスト
    if ping(PINGHOST):
        printMessage("Already network authentication has been completed.")
        return

    for i in range(3):
        # ログインフォームからタグ値を取得
        # html = readTestFile()
        try:
            print(os.environ['http_proxy'])
        except KeyError:
            print('no proxy environ')
        else:
            os.environ.pop('http_proxy')
            os.environ.pop('https_proxy')

        html = getForm()
        #value = getTagValue(html)
        #print(value)

        #if not value:
        #    time.sleep(1)
        #    continue

        # usernameとpasswordを取得
        username = getpass.getuser()
        username = sys.argv[1]
        password = getPassword(username)

        # 認証と結果の取得
        html = postForm(username, password, url="")
        result, msg = getResult(html)
        printMessage(msg)
        if result == SUCCESS:
            return

    printMessage("Authentication was failed.")


if __name__ == "__main__":
    main()
