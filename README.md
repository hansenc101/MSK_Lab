# MSK_Lab
author: github.com/hansenc101

===== TL;DR =====

Matlab code to simulate a communications system that executes the following:

Text -> ASCII Hexadecimal -> bitstream -> add post/pre-amble -> Encoding -> MSK Waveform -> Transmit -> Channel of Choice (I am using audio) -> Receive -> Demodulate/Filter -> 
decode  -> sync bits and remove post/pre-amble -> original bitstream -> ASCII Hex -> Original Text

==== Purpose ====

This is a Digital Communications lab I am doing for university. Hopefully you can learn something from it as well.

==== Basic Description ====

This repository maintains code written in Matlab that simulates a digital communication system. The software starts with some example text data that is imported from a .txt file. 
The imported text is then converted to hexadecimal, then to bits, using ASCII. Once the bitstream is generated, a preamble and postamble are added to the bitstream for syncing 
later on in the project, after transmission. Once the post and preamble are added, these bits are then encoded using a convolutional encoder with a rate of 1/2 and K = 7. After 
this new bitstream is generated,  an MSK modulated waveform is created, carrying this new bitstream. The MSK is modulated with a carrier frequency of 1200 Hz, baud of 800, and 
sample rate of 192kHz. This waveform is then transmitted and received over an audio channel. The audio channel can either be over wire or air. Both methods are demonstrated and 
the results are documented. Once the waveform is received (rx), the rx waveform is synced and demodulated through the use of matched filters. The new rx bitstream is then decoded 
using a Viterbi algorithm. The decoded bitstream is then synced with the post and preamble bits again, and converted to ASCII hexadecimal, then to bits again. The rx message is 
then output to the Matlab console. 

==== Notice ====
All of my documentation is contained in the 'Lab 05 Notebook.docx' file. Theory of operation, progression of project, incremental demonstrations of functionality, plots of waveforms throughout simulation, and answers to questions pertaining to the material are all covered.
