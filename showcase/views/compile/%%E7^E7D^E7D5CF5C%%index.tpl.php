<?php /* Smarty version 2.6.18, created on 2008-04-29 17:49:45
         compiled from view:jobs/index.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'categories', 'view:jobs/index.tpl', 115, false),array('function', 'math', 'view:jobs/index.tpl', 125, false),)), $this); ?>
<div id="title">
	<img src="/images/clients/vodafone/title_campaign.png"/>
</div>

<div class="jobs">
	<h4><?php echo $this->_tpl_vars['job']->article->title; ?>
</h4>
	
	<div class="leftCol<?php if ($this->_tpl_vars['media']): ?>_reversed<?php endif; ?>">
		<?php if ($this->_tpl_vars['media']): ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "view:player.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		<?php else: ?>
		<div class="thumb">
			<img src="<?php echo $this->_tpl_vars['job']->image['MAIN']->path; ?>
"/>
		</div>
		<ul>
			<li class="first"><strong>Published:</strong> <?php echo $this->_tpl_vars['job']->published->toString('dd MMMM yy'); ?>
</li>
			<li><strong>Job Number: </strong><?php echo $this->_tpl_vars['job']->number; ?>
</li>
		</ul>
		<?php endif; ?>
	</div>
	
	<div class="rightCol<?php if ($this->_tpl_vars['media']): ?>_reversed<?php endif; ?>">
		
		<?php if (! $this->_tpl_vars['media']): ?>
		<div class="contentBox">
			<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('description_<?php echo $this->_tpl_vars['job']->id; ?>
'))" title="Contract">-</span>Description</div>
			<div id="description_<?php echo $this->_tpl_vars['job']->id; ?>
">
				<div class="content">
					<?php echo $this->_tpl_vars['job']->article; ?>

				</div>
			</div>
		</div>
		<?php else: ?>
        <?php if ($this->_tpl_vars['media']->description): ?>
		<div class="contentBox">
			<div class="heading">
				<span class="animateControl" onclick="animate(this, document.getElementById('description_<?php echo $this->_tpl_vars['media']->id; ?>
'))" title="Contract">-</span>
				Description
			</div>
			<div id="description_<?php echo $this->_tpl_vars['media']->id; ?>
">
				<div class="content">
					<?php echo $this->_tpl_vars['media']->description; ?>

				</div>
			</div>
		</div>
		<?php endif; ?>
        
		<div class="contentBox">
			<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('download_<?php echo $this->_tpl_vars['media']->id; ?>
'))" title="Contract">-</span>Download</div>
			<div id="download_<?php echo $this->_tpl_vars['media']->id; ?>
">
				<?php if ($this->_tpl_vars['media']->cue): ?>
				<div class="content">
					<a href="/download/<?php echo $this->_tpl_vars['media']->cue; ?>
" class="icon_documents"><?php echo $this->_tpl_vars['media']->cue->name; ?>
</a>
				</div>
				<?php endif; ?>
				<?php if ($this->_tpl_vars['media']->schedule): ?>
				<div class="content">
					<a href="/download/<?php echo $this->_tpl_vars['media']->schedule; ?>
" class="icon_documents"><?php echo $this->_tpl_vars['media']->schedule->name; ?>
</a>
				</div>
				<?php endif; ?>
				<div class="content">
					<a href="/download/<?php echo $this->_tpl_vars['media']; ?>
" class="icon_<?php echo $this->_tpl_vars['media']->category->identifier; ?>
"><?php echo $this->_tpl_vars['media']->name; ?>
</a>
				</div>
			</div>
		</div>
		
		<?php endif; ?>
		
		<div class="contentBox">
			<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('breif_<?php echo $this->_tpl_vars['job']->id; ?>
'), 0.2)" title="Contract">-</span>Download Brief Sheet</div>
			<div id="breif_<?php echo $this->_tpl_vars['job']->id; ?>
">
				<div class="content">
					<a href="/download/<?php echo $this->_tpl_vars['job']->document; ?>
" class="icon_documents"><?php echo $this->_tpl_vars['job']->document->name; ?>
</a>
				</div>
			</div>
		</div>
		
		<?php if ($this->_tpl_vars['media']): ?>
		<ul class="marginBottom">
			<li class="first"><a href="/jobs/<?php echo $this->_tpl_vars['job']->id; ?>
">Back</a></li>
		</ul>
		<?php endif; ?>
		
	</div>
	
</div>
<?php if ($this->_tpl_vars['media']): ?>
<div class="bg_554">
	<div class="contentBox">
		<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('description_<?php echo $this->_tpl_vars['job']->id; ?>
'))" title="Contract">-</span>Campaign Description</div>
		<div id="description_<?php echo $this->_tpl_vars['job']->id; ?>
">
			<div class="content">
				<?php echo $this->_tpl_vars['job']->article; ?>

			</div>
		</div>
	</div>
</div>
<?php endif; ?>


<div id="phases">
	
	<?php $_from = $this->_tpl_vars['job']->content; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['cont'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['cont']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['cont']):
        $this->_foreach['cont']['iteration']++;
?>
		<div class="bg_554">
			<div style="float:right;"><?php echo $this->_tpl_vars['cont']->published->toString('dd MMMM yy'); ?>
</div>
			<h4><span class="animateControl" onclick="animate(this, document.getElementById('media_<?php echo ($this->_foreach['cont']['iteration']-1); ?>
'))" title="<?php if (! ($this->_foreach['cont']['iteration'] <= 1)): ?>Expand<?php else: ?>Contract<?php endif; ?>"><?php if (! ($this->_foreach['cont']['iteration'] <= 1)): ?>+<?php else: ?>-<?php endif; ?></span><a href="/content/<?php echo $this->_tpl_vars['cont']->id; ?>
/<?php echo $this->_tpl_vars['job']->id; ?>
"><?php echo $this->_tpl_vars['cont']->article->title; ?>
</a></h4>
			
			<div id="media_<?php echo ($this->_foreach['cont']['iteration']-1); ?>
"<?php if (! ($this->_foreach['cont']['iteration'] <= 1)): ?> style="display:none;"<?php endif; ?>>
				<?php if ($this->_tpl_vars['cont']->article): ?>
				<div class="marginBottom">
					<?php echo $this->_tpl_vars['cont']->article; ?>

				</div>
				<?php endif; ?>
				<div class="contentBox">
					<?php echo smarty_function_categories(array('obj' => $this->_tpl_vars['cont'],'type' => 'tabs'), $this);?>

					<div class="heading">Media Download</div>
				
					<?php $this->assign('catindex', 0); ?>
					<?php $_from = $this->_tpl_vars['cont']->media; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['media'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['media']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['media']):
        $this->_foreach['media']['iteration']++;
?>
						<?php if (! $this->_tpl_vars['catname'] || $this->_tpl_vars['catname'] != $this->_tpl_vars['media']->category): ?>
							<?php if ($this->_tpl_vars['catname'] != $this->_tpl_vars['media']->category && ! ($this->_foreach['media']['iteration'] <= 1)): ?>
							</div>
							<?php endif; ?>
							<?php $this->assign('catname', $this->_tpl_vars['media']->category); ?>
							<?php echo smarty_function_math(array('equation' => 'x + y','x' => $this->_tpl_vars['catindex'],'y' => 1,'assign' => 'catindex'), $this);?>

							<div id="cont<?php echo $this->_tpl_vars['cont']->id; ?>
_<?php echo $this->_tpl_vars['catindex']; ?>
">
						<?php endif; ?>
					
						<div class="content media">
						<?php if ($this->_tpl_vars['media']->filetype_name): ?>
							<div class="icon_<?php echo $this->_tpl_vars['media']->category->identifier; ?>
">
									<div class="media_name">
										<?php echo $this->_tpl_vars['media']->name; ?>

									</div>
								<div class="media_container">
									<?php if ($this->_tpl_vars['media']->filesize): ?>
									<div class="media_filesize">
										<strong>Filesize:</strong> <?php echo $this->_tpl_vars['media']->filesize; ?>

									</div>
									<?php endif; ?>
								</div>
								<div class="media_description">
									<?php echo $this->_tpl_vars['media']->description; ?>

								</div>
								<div class="media_links">
								<?php if ($this->_tpl_vars['media']->cue): ?>
									<a href="/download/<?php echo $this->_tpl_vars['media']->cue; ?>
" title="Download <?php echo $this->_tpl_vars['media']->cue->name; ?>
">Cue Sheet</a>
								<?php endif; ?>
								<?php if ($this->_tpl_vars['media']->schedule): ?>
									<a href="/download/<?php echo $this->_tpl_vars['media']->schedule; ?>
" title="Download <?php echo $this->_tpl_vars['media']->schedule->name; ?>
">Schedule</a>
								<?php endif; ?>
								<?php if ($this->_tpl_vars['media']->stream_path): ?>
									<a href="/jobs/<?php echo $this->_tpl_vars['job']->id; ?>
/<?php echo $this->_tpl_vars['media']->identifier; ?>
">Play</a>
								<?php endif; ?>
								<?php if ($this->_tpl_vars['media']->path): ?>
									<?php if ($this->_tpl_vars['media']->isWeblink): ?>
									<a href="<?php echo $this->_tpl_vars['media']->path; ?>
" target="blank" title="Open <?php echo $this->_tpl_vars['media']->name; ?>
">Open Website</a>
									<?php else: ?>
									<a href="/download/<?php echo $this->_tpl_vars['media']; ?>
">Download</a>
									<?php endif; ?>
								<?php endif; ?>
								</div>
							</div>
						<?php endif; ?>
						</div>
						
						<?php if (($this->_foreach['media']['iteration'] == $this->_foreach['media']['total'])): ?>
							</div>
						<?php endif; ?>
					<?php endforeach; else: ?>
					<div class="content">
						There is currently no media available to download for this phase
					</div>
					<?php endif; unset($_from); ?>
				</div>

			</div>
		
		</div>
	<?php endforeach; endif; unset($_from); ?>
	
</div>
