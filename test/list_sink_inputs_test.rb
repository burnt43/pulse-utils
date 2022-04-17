require './test/initialize'

module PulseUtils
  module Testing
    class LinkSinkInputsTest < PulseUtils::Testing::Test
      def test_parse
        PulseUtils::Parsers::ListSinkInputs.new(
<<-EOF
2 sink input(s) available.
    index: 3
	driver: <protocol-native.c>
	flags: START_CORKED 
	state: RUNNING
	sink: 1 <alsa_output.usb-FX-AUDIO_FX-AUDIO-DAC-X6-00.analog-stereo>
	volume: front-left: 64488 /  98% / -0.42 dB,   front-right: 64488 /  98% / -0.42 dB
	        balance 0.00
	muted: no
	current latency: 89.00 ms
	requested latency: 75.00 ms
	sample spec: float32le 2ch 48000Hz
	channel map: front-left,front-right
	             Stereo
	resample method: copy
	module: 10
	client: 2 <Firefox>
	properties:
		media.name = "AudioStream"
		application.name = "Firefox"
		native-protocol.peer = "UNIX socket client"
		native-protocol.version = "35"
		application.process.id = "611"
		application.process.user = "jcarson"
		application.process.host = "dungeon42069"
		application.process.binary = "firefox"
		application.language = "en_US.UTF-8"
		window.x11.display = ":0"
		application.process.machine_id = "9f0c0b6d3c41490984b469ecea094ba6"
		application.process.session_id = "1"
		application.icon_name = "firefox"
		module-stream-restore.id = "sink-input-by-application-name:Firefox"
    index: 4
	driver: <protocol-native.c>
	flags: START_CORKED 
	state: RUNNING
	sink: 1 <alsa_output.usb-FX-AUDIO_FX-AUDIO-DAC-X6-00.analog-stereo>
	volume: front-left: 0 /   0% / -inf dB,   front-right: 0 /   0% / -inf dB
	        balance 0.00
	muted: no
	current latency: 89.00 ms
	requested latency: 75.00 ms
	sample spec: float32le 2ch 48000Hz
	channel map: front-left,front-right
	             Stereo
	resample method: copy
	module: 10
	client: 2 <Firefox>
	properties:
		media.name = "AudioStream"
		application.name = "Firefox"
		native-protocol.peer = "UNIX socket client"
		native-protocol.version = "35"
		application.process.id = "611"
		application.process.user = "jcarson"
		application.process.host = "dungeon42069"
		application.process.binary = "firefox"
		application.language = "en_US.UTF-8"
		window.x11.display = ":0"
		application.process.machine_id = "9f0c0b6d3c41490984b469ecea094ba6"
		application.process.session_id = "1"
		application.icon_name = "firefox"
		module-stream-restore.id = "sink-input-by-application-name:Firefox"
EOF
        ).parse.tap do |result|
          puts "\033[0;36m#{result.to_s}\033[0;0m"
          assert(true)
        end
      end
    end
  end
end
