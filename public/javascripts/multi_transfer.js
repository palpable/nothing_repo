window.addEvent('domready', function() {
	$('add').addEvent('click', function() {
		$('select1').getSelected().each(function(el) {
			el.inject($('select2'));
		});
	});
	$('remove').addEvent('click', function() {
		$('select2').getSelected().each(function(el) {
			el.inject($('select1'));
		});
	});
});

function select_employee(hello)
{
  var hello=document.getElementById('select2');
    len = hello.length
    i = 0
    for (i = 0; i < len; i++) 
    {
      hello[i].selected = true;
    }
}
