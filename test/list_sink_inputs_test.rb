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

          assert_equal(2, result[:number_available])

          assert(result[:sink_inputs].key?(3))

          assert_equal('<protocol-native.c>',
                       result.dig(:sink_inputs, 3, :driver))
          assert_equal('START_CORKED',
                       result.dig(:sink_inputs, 3, :flags))
          assert_equal('1 <alsa_output.usb-FX-AUDIO_FX-AUDIO-DAC-X6-00.analog-stereo>',
                       result.dig(:sink_inputs, 3, :sink))
          assert_equal('front-left: 64488 /  98% / -0.42 dB,   front-right: 64488 /  98% / -0.42 dB balance 0.00',
                       result.dig(:sink_inputs, 3, :volume))
          assert_equal('no',
                       result.dig(:sink_inputs, 3, :muted))
          assert_equal('89.00 ms',
                       result.dig(:sink_inputs, 3, :'current latency'))
          assert_equal('75.00 ms',
                       result.dig(:sink_inputs, 3, :'requested latency'))
          assert_equal('float32le 2ch 48000Hz',
                       result.dig(:sink_inputs, 3, :'sample spec'))
          assert_equal('front-left,front-right Stereo',
                       result.dig(:sink_inputs, 3, :'channel map'))
          assert_equal('copy',
                       result.dig(:sink_inputs, 3, :'resample method'))
          assert_equal('10',
                       result.dig(:sink_inputs, 3, :module))
          assert_equal('2 <Firefox>',
                       result.dig(:sink_inputs, 3, :client))
          assert_equal('AudioStream',
                       result.dig(:sink_inputs, 3, :properties, :media, :name))
          assert_equal('Firefox',
                       result.dig(:sink_inputs, 3, :properties, :application, :name))
          assert_equal('UNIX socket client',
                       result.dig(:sink_inputs, 3, :properties, :'native-protocol', :peer))
          assert_equal('35',
                       result.dig(:sink_inputs, 3, :properties, :'native-protocol', :version))
          assert_equal('611',
                       result.dig(:sink_inputs, 3, :properties, :application, :process, :id))
          assert_equal('jcarson',
                       result.dig(:sink_inputs, 3, :properties, :application, :process, :user))
          assert_equal('dungeon42069',
                       result.dig(:sink_inputs, 3, :properties, :application, :process, :host))
          assert_equal('firefox',
                       result.dig(:sink_inputs, 3, :properties, :application, :process, :binary))
          assert_equal('en_US.UTF-8',
                       result.dig(:sink_inputs, 3, :properties, :application, :language))
          assert_equal(':0',
                       result.dig(:sink_inputs, 3, :properties, :window, :x11, :display))
          assert_equal('9f0c0b6d3c41490984b469ecea094ba6',
                       result.dig(:sink_inputs, 3, :properties, :application, :process, :machine_id))
          assert_equal('1',
                       result.dig(:sink_inputs, 3, :properties, :application, :process, :session_id))
          assert_equal('firefox',
                       result.dig(:sink_inputs, 3, :properties, :application, :icon_name))
          assert_equal('sink-input-by-application-name:Firefox',
                       result.dig(:sink_inputs, 3, :properties, :'module-stream-restore', :id))
        end
      end
    end
  end
end
