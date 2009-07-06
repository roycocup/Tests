<object width="320"
		height="309"
		pluginspage="http://www.microsoft.com/Windows/MediaPlayer"
		codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=6,4,5,715"
		type="video/x-ms-asf"
		id="streamedChatPlayer">
		<param name="fileName" 		value="{$media->stream_path}"></param>
		<param name="wmode" 		value="transparent"></param>
		<param name="autoStart" 	value="true"></param>
		<param name="showStatusBar" value="true"></param>
		<param name="showControls" 	value="true"></param>

		<embed	src="{$media->stream_path}"
			name="player"
			width="320"
			type="application/x-ms-asf"
			pluginspage="http://www.microsoft.com/Windows/MediaPlayer"
			autoStart="1"
			showcontrols="1"
			showstatusbar="1"
			showaudiocontrols="1"
			stretchtofit="0"></embed>
</object>