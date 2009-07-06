<?php /* Smarty version 2.6.18, created on 2008-04-29 17:46:30
         compiled from view:player.tpl */ ?>
<object width="320"
		height="309"
		pluginspage="http://www.microsoft.com/Windows/MediaPlayer"
		codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=6,4,5,715"
		type="video/x-ms-asf"
		id="streamedChatPlayer">
		<param name="fileName" 		value="<?php echo $this->_tpl_vars['media']->stream_path; ?>
"></param>
		<param name="wmode" 		value="transparent"></param>
		<param name="autoStart" 	value="true"></param>
		<param name="showStatusBar" value="true"></param>
		<param name="showControls" 	value="true"></param>

		<embed	src="<?php echo $this->_tpl_vars['media']->stream_path; ?>
"
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