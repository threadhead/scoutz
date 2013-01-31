CKEDITOR.editorConfig = function( config ) {
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

  config.toolbar = 'Easy';

  config.toolbar_Easy =
      [
          ['Bold','Italic','Strike'],
          ['BulletedList','NumberedList','Blockquote'],
          ['JustifyLeft','JustifyCenter','JustifyRight'],
          ['Link','Unlink'],
          ['Subscript', 'Superscript'],
          ['Image', 'Attachment', 'Flash', 'Embed'],
          ['YahooMaps', 'Dictionary'],
          '/',
          ['Format'],
          ['Underline', 'JustifyBlock', 'TextColor'],
          ['PasteText','PasteFromWord','RemoveFormat'],
          ['SpecialChar'],
          ['Outdent','Indent'],
          ['Undo','Redo'],
          ['Source']
      ];
};
