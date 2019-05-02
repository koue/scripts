# -*- coding: utf-8 -*-

import pytest

from myte import myte

cf = "tests/commands.txt"

def test_one_no():
    expected = []
    expected.append("First line.")
    assert myte.runme(cf, "tests/one_no.txt") == expected

def test_one_yes():
    expected = []
    expected.append("Hello!")
    assert myte.runme(cf, "tests/one_yes.txt") == expected

def test_two():
    expected = []
    expected.append("First line.")
    expected.append("Hello!")
    assert myte.runme(cf, "tests/two.txt") == expected

def test_loop():
    expected = []
    expected.append("First line.")
    expected.append("Hello!")
    expected.append("This is a apple.")
    expected.append("This is a banana.")
    expected.append("This is a citrus.")
    expected.append("That's it!")
    expected.append("Last line.")
    assert myte.runme(cf, "tests/loop.txt") == expected

def test_if():
    expected = []
    expected.append("First line.")
    expected.append("This is a banana.")
    expected.append("That's it!")
    expected.append("Last line.")
    assert myte.runme(cf, "tests/if.txt") == expected

def test_more():
    expected = []
    expected.append("First line.")
    expected.append("This is a banana.")
    expected.append("show That's it! more")
    expected.append("Last line.")
    assert myte.runme(cf, "tests/more.txt") == expected
