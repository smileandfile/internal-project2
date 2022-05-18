$(function() {
  $('[data-indian-number-string]').each(function(index, item) {
    $el = $(item);
    $el.text(toIndianNumberString($el.data('indianNumberString')));
  });
});

function toIndianNumberString(inputNumber) {
  var ONE_CRORE = 10000000;
  var ONE_LAKH = 100000;
  var number = Number(inputNumber);

  if (number >= ONE_CRORE) {
    croreValue = number / ONE_CRORE;
    return croreValue + ' cr' + (croreValue == 1 ? '' : 's');
  }

  if (number >= ONE_LAKH) {
    croreValue = number / ONE_LAKH;
    return croreValue + ' lakh' + (croreValue == 1 ? '' : 's');
  }

  return number;
}