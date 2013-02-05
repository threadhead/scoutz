CKEDITOR.config.toolbar = 'Easy';
CKEDITOR.config.toolbar_Easy =
  [
    // { name: 'document', items : [ 'Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates' ] },
    { name: 'document', items : [ 'Source' ] },
    // { name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
    { name: 'clipboard', items : [ 'Cut','Copy','Paste','-','Undo','Redo' ] },
    // { name: 'editing', items : [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
    // { name: 'forms', items : [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ] },
    // { name: 'links', items : [ 'Link','Unlink','Anchor' ] },
    { name: 'links', items : [ 'Link','Unlink'] },
    // { name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ] },
    { name: 'insert', items : [ 'Image','Table','HorizontalRule'] },
    // { name: 'tools', items : [ 'Maximize', 'ShowBlocks','-','About' ] },
    // { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv', '-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
    { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote', '-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
    { name: 'tools', items : [ 'About' ] },
    '/',
    { name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
    { name: 'colors', items : [ 'TextColor','BGColor' ] },
    { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
  ];


// CKEDITOR.config.toolbarGroups = [
// // { name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
// { name: 'document', groups: [ 'mode' ] },
// // { name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
// { name: 'clipboard', groups: [ 'undo' ] },
// // { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ] },
// // { name: 'tools' },
// { name: 'about' },
// '/',
// // { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
// { name: 'basicstyles', groups: [ 'basicstyles' ] },
// { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align' ] }, // , 'bidi'
// // { name: 'forms' },
// '/',
// { name: 'styles' },
// { name: 'colors' },
// { name: 'links' },
// // { name: 'insert' },
// // { name: 'others' }
// ];


// CKEDITOR.editorConfig = function( config ) {
  // config.language = 'fr';
  // config.uiColor = '#AADC6E';
  // config.toolbar = [
  //     [ 'Source', '-', 'Bold', 'Italic' ]
  //   ];
  // config.toolbarGroups = [
  //   // { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
  //   { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
  //   { name: 'links' },
  //   { name: 'insert' },
  //   { name: 'forms' },
  //   { name: 'tools' },
  //   // { name: 'document',    groups: [ 'mode', 'document', 'doctools' ] },
  //   { name: 'others' },
  //   '/',
  //   { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
  //   { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
  //   { name: 'styles' },
  //   { name: 'colors' },
  //   { name: 'about' }
  // ];

//   config.toolbar = 'Easy';

//   config.toolbar_Easy =
//       [
//           ['Bold','Italic','Strike'],
//           ['BulletedList','NumberedList','Blockquote'],
//           ['JustifyLeft','JustifyCenter','JustifyRight'],
//           ['Link','Unlink'],
//           ['Subscript', 'Superscript'],
//           ['Image', 'Attachment', 'Flash', 'Embed'],
//           ['YahooMaps', 'Dictionary'],
//           '/',
//           ['Format'],
//           ['Underline', 'JustifyBlock', 'TextColor'],
//           ['PasteText','PasteFromWord','RemoveFormat'],
//           ['SpecialChar'],
//           ['Outdent','Indent'],
//           ['Undo','Redo'],
//           ['Source']
//       ];
// };
