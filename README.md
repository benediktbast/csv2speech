# CSV to speech converter

Requires MAC OS say command, sox, and ffmpeg if you want to convert the output to mp3

## Usage
Arguments:
- name of csv file
- line number to start
- line number to stop

`./csv2speech.sh example.csv 1 5`

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
