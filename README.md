# CSV to speech converter

Requires MAC OS say command, sox, and ffmpeg if you want to convert the output to mp3

## Usage
Arguments:
- name of csv file
- name of voice 1
- name of voice 2
- line number to start
- line number to stop
- output format (optional) can be set to `mp3` if you have ffmpeg installed

You can use the example CSV file with German and Thai Translation to convert lines 1 to 7

`./csv2speech.sh example_de_th.csv Daniel Kanya 1 12`

with conversion to mp3

`./csv2speech.sh example_de_th.csv Daniel Kanya 1 12 mp3`  

## Find the right voice
The command `say -v '?'` will list you all available voices on your system

## Modulating the speech

The following effect tags can be used also in the csv file to modulate the speech more natural

* `[[ slnc 5000 ]]` silence for 5s.
* `[[volm 0.9]]` changes the volume to the indicated level.
* `[[volm +0.1]]` increases the volume by the indicated level.
* `[[rate 150]]` changes the speed
* `[[pbas 50]]` changes the pitch.
* `[[ rset ]]` resets all these parameters to default
* `‘word’` quotes also put the emphasis on the word.
