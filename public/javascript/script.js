$(document).ready(function() {
  jQuery(".content").hide();
  jQuery(".heading").click(function()
  {
    jQuery(this).next(".content").slideToggle(500);
  });
});
</script>


// .layer1 {
// margin: 0;
// padding: 0;
// width: 500px;
// }

// .heading {
// margin: 1px;
// color: #fff;
// padding: 3px 10px;
// cursor: pointer;
// position: relative;
// background-color:#c30;
// }
// .content {
// padding: 5px 10px;
// background-color:#fafafa;
// }
// p { padding: 5px 0; }