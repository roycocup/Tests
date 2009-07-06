<?php /* Smarty version 2.6.18, created on 2008-04-29 17:49:36
         compiled from view:index/index.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'cat', 'view:index/index.tpl', 53, false),array('function', 'catIcons', 'view:index/index.tpl', 63, false),array('function', 'pager', 'view:index/index.tpl', 88, false),)), $this); ?>

<div id="title">
	<img src="/images/clients/vodafone/title_campaigns.png"/>
</div>

<?php if ($this->_tpl_vars['jobs']): ?>

<?php $_from = $this->_tpl_vars['jobs']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['item']):
?>
	<?php if ($this->_tpl_vars['item']->id): ?>
	<div class="jobs">
		<h4><a href="/jobs/<?php echo $this->_tpl_vars['item']->id; ?>
"><?php echo $this->_tpl_vars['item']->article->title; ?>
</a></h4>
		
		<div class="leftCol">
			<div class="thumb">
				<a href="/jobs/<?php echo $this->_tpl_vars['item']->id; ?>
"><img src="<?php echo $this->_tpl_vars['item']->image['THUMB']->path; ?>
"/></a>
			</div>
			<ul>
				<li class="first"><strong>Published:</strong> <?php echo $this->_tpl_vars['item']->published->toString('dd MMMM yy'); ?>
</li>
				<li><strong>Job Number: </strong><?php echo $this->_tpl_vars['item']->number; ?>
</li>
				<li><a href="/jobs/<?php echo $this->_tpl_vars['item']->id; ?>
">more details...</a></li>
			</ul>
		</div>
		
		<div class="rightCol">
			
			<div class="bg_324">
				<div class="contentBox">
					<div class="heading">
						<span class="animateControl" onclick="animate(this, document.getElementById('description_<?php echo $this->_tpl_vars['item']->id; ?>
'),0.4)" title="Contract">-</span>
						Description
					</div>
					<div id="description_<?php echo $this->_tpl_vars['item']->id; ?>
">
						<div class="content">
							<?php echo $this->_tpl_vars['item']->article->body; ?>

						</div>
					</div>
				</div>
			</div>
			
			<?php if ($this->_tpl_vars['item']->content != null): ?>
            	<!--
				<ul class="tabs">
					<li class="on"><a href="javascript:;">Television</a></li>
					<li><a href="javascript:;">Radio</a></li>
					<li><a href="javascript:;">Documents</a></li>
				</ul>
				-->
				<div class="bg_324">
					<?php $_from = $this->_tpl_vars['item']->content; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['cont'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['cont']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['cont']):
        $this->_foreach['cont']['iteration']++;
?>
					<?php if ($this->_tpl_vars['cont']->media): ?>
					<div class="contentBox">
							<div class="heading">
								<span class="animateControl" onclick="animate(this, document.getElementById('phase_<?php echo ((is_array($_tmp=$this->_tpl_vars['item']->id)) ? $this->_run_mod_handler('cat', true, $_tmp, ($this->_foreach['cont']['iteration']-1)) : smarty_modifier_cat($_tmp, ($this->_foreach['cont']['iteration']-1))); ?>
'),0.4)" title="<?php if (! ($this->_foreach['cont']['iteration'] <= 1)): ?>Expand<?php else: ?>Contract<?php endif; ?>"><?php if (! ($this->_foreach['cont']['iteration'] <= 1)): ?>+<?php else: ?>-<?php endif; ?></span>
								<?php echo $this->_tpl_vars['cont']->article->title; ?>

							</div>
							<div id="phase_<?php echo ((is_array($_tmp=$this->_tpl_vars['item']->id)) ? $this->_run_mod_handler('cat', true, $_tmp, ($this->_foreach['cont']['iteration']-1)) : smarty_modifier_cat($_tmp, ($this->_foreach['cont']['iteration']-1))); ?>
"<?php if (! ($this->_foreach['cont']['iteration'] <= 1)): ?> style="display:none;"<?php endif; ?>>
								<div class="content">
									<div class="specs">
										<div class="key">Published</div>
										<div class="value"><?php echo $this->_tpl_vars['cont']->published->toString('dd MMMM yy'); ?>
</div>
										<div class="key">Media</div>
										<div class="value">
											<?php echo smarty_function_catIcons(array('obj' => $this->_tpl_vars['cont']), $this);?>

										</div>
									</div>
									<a href="/content/<?php echo $this->_tpl_vars['cont']->id; ?>
/<?php echo $this->_tpl_vars['item']->id; ?>
" class="details">more...</a>
								</div>
							</div>
					</div>
					<?php endif; ?>
					<?php endforeach; endif; unset($_from); ?>
				</div>
			
			<?php endif; ?>
		</div>
		
	</div>
	<?php endif; ?>
<?php endforeach; endif; unset($_from); ?>

<?php $this->assign('limit', $this->_tpl_vars['jobs']['limit']); ?>
<?php $this->assign('rows', $this->_tpl_vars['jobs']['totalrows']); ?>
<!--
offset: <?php echo $this->_tpl_vars['offset']; ?>
<br/>
rows: <?php echo $this->_tpl_vars['rows']; ?>
<br/>
limit: <?php echo $this->_tpl_vars['limit']; ?>
<br/>
-->
<?php echo smarty_function_pager(array('rowcount' => $this->_tpl_vars['rows'],'limit' => $this->_tpl_vars['limit'],'posvar' => 'pages','pos' => $this->_tpl_vars['offset']), $this);?>


<?php endif; ?>