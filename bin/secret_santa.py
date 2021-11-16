#!/usr/bin/env python
# encoding: utf-8


from __future__ import print_function

import textwrap
import random
import operator
import smtplib
from email.mime.text import MIMEText

try:
    from mock import MagicMock
    assert MagicMock # silence pyflakes
except ImportError:
    from unittest.mock import MagicMock


# Config

TEST_MODE = True # Set to false to display the email instead of sending it

FROMADDR = 'your_address@gmail.com' # Has to be Gmail
PASSWORD = '' # App specific password (generate one)

GIVERS  = [
        ('Isobel',   'isobel.keough@gmail.com'),
        ('Kevin',    'kev.keough@gmail.com'),
        ('James',    'jameskeough27@gmail.com'),
	('Laura',    'keolaura@gmail.com'),
        ('Matthias', 'matthiasamd@gmail.com'),
        ('Isabelle', 'jollyferriol@gmail.com'),
        ('Jean-Luc', 'chossartjolly@hotmail.com'),
        ('Marion',   'marionchossart@hotmail.com'),
        ('Romain',   'romainchossart@gmail.com'),
]

email_subject = 'Secret santa for Chrismas in California'


# Code

class SMTPServer(object):

    def __init__(self, address, fromaddr, password):
        self.server = smtplib.SMTP(address)
        self.fromaddr = fromaddr
        self.password = password

    def __enter__(self):
        self.server.starttls()
        self.server.login(self.fromaddr, self.password)
        return self.server

    def __exit__(self, *args):
        self.server.quit()


def send_secret_santa(test=False):
    targets = GIVERS[:]
    while any(map(operator.eq, GIVERS, targets)):
        random.shuffle(targets)

    people_and_emails = '\n'.join(['- %s (%s)' % giver for giver in GIVERS])

    print('List of santas - DON\'T LOOK! But keep it somewhere in case an email gets lost')

    with SMTPServer('smtp.gmail.com:587', FROMADDR, PASSWORD) as server:
        if test:
            server.sendmail = MagicMock(side_effect=lambda fromaddr, toaddr, msg: print(msg))

        for i, (giver, giver_email) in enumerate(GIVERS):
            msg = MIMEText(textwrap.dedent('''
            Dear %(name)s,

            This is secret santa! You have to give someone a present (but don't tell him/her, it's a secret!).

            Your secret santa is... %(target)s!

            It's dangerous to be alone, so to help you in your quest, here is the list of people participating:
            %(people_and_emails)s

            Have fun!

            --
            Santa Claus (ho ho ho!)
            ''') % {
                'name': giver,
                'target': targets[i][0],
                'people_and_emails': people_and_emails,
                })
            msg['Subject'] = email_subject

            print('%s needs to buy a present to %s.' % (giver, targets[i][0]))

            server.sendmail(FROMADDR, giver_email, msg.as_string())


if __name__ == '__main__':
    send_secret_santa(test=TEST_MODE)
