#!/bin/bash
# Monitor system processes and their memory usage

# --sort=-%mem > sorts in desceding order for memory %
# head -n 10 > gives top 10 results
ps aux --sort=-%mem | head -n 10