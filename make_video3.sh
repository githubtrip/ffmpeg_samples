#!/bin/bash

# get duration of audio file
DURATION=$( ffprobe -v error -show_entries format=duration \
  -of default=noprint_wrappers=1:nokey=1 audio.mp3 )
  
# set the title
TITLE='My channel title'

# for left or center align you can use full text
TEXT="Specify the amount of time that non-silence
must be detected before it stops trimming audio. 
By increasing the duration, bursts of noises can 
be treated as silence and trimmed off. 
Default value is 0."


# for right align you need cut text to lines and drawtext each line
TEXT_LINE1="Specify the amount of time that non-silence"
TEXT_LINE2="must be detected before it stops trimming audio."
TEXT_LINE3="By increasing the duration, bursts of noises can"
TEXT_LINE4="be treated as silence and trimmed off"

# for testing you can set shortest value for DURATION  
#DURATION=10

ffmpeg -y -loglevel info -ss 0 -t $DURATION -i audio.mp3 -i cover.png -i watermark.png -i background.png \
-filter_complex "[3:v]  \
drawtext=fontfile=Nunito-SemiBold.ttf: text='$TITLE':x=80: y=160: fontsize=36: fontcolor=white, \
drawtext=fontfile=Nunito-Regular.ttf: text='$TEXT':x=80: y=200: fontsize=24: fontcolor=white  [ v0 ]; \
[0:a]showwaves=s=400x100:n=5: r=25: mode=cline: scale=sqrt : colors=0x666666|0x555555 [v3] ; \
[1:v] scale=w=400:h=400 [v1]; \
[2:v] scale=w=244:h=-2 [v2]; \
[v0][v1] overlay=x=800:y=160 [v0v1];  \
[v0v1][v2] overlay=x=80:y=560 [v0v1v2]; \
[v0v1v2][v3] overlay=x=800:y=560 [v] " -shortest -map '[v]' -map 'a' -c:a aac -f mp4 out.mp4


