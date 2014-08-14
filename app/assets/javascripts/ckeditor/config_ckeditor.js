$(document).ready(function() {
    if (typeof CKEDITOR != 'undefined') {
      CKEDITOR.replace('ckeditor', { customConfig: '/assets/ckeditor_config.js' });
    } else {
      // console.log("call in 50ms");
      setTimeout(arguments.callee, 50);
    };
});
