#!/bin/bash

sudo apt install -y --no-install-recommends gkrellm
echo gkrellm --geometry -0-0 \& > .xsessionrc
