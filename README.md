# (On Server) Uptime Monitor

Run this on your server to monitor uptime and take action accordingly.

## Setup

These scripts should be executed automatically using some other tool to function as intended.

### Cronjobs

`launch.sh` file is to be used with cronjobs. Run the command below to edit the crontab file safely:

```
crontab -e
```

Then add this to the end of the file to run it every 10 minutes:

```
*/10 * * * * /srv/on-server-uptime-monitor/launch_monitor.sh
```


### License

MIT License: Copyright (c) 2025 Hirusha Adikari

```
MIT License

Copyright (c) 2025 Hirusha Adikari

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
