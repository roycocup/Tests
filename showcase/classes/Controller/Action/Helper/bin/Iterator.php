<?php


interface Iterator {
function current();
function next();
function rewind();
function key();
function valid();
function seek($index);
}