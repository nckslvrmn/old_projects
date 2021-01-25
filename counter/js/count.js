
function add() {
  count = parseInt(document.getElementById("count").value);
  count += 1;
  document.getElementById("count").value = count; 
}

function subtract() {
  count = parseInt(document.getElementById("count").value);
  count -= 1;
  document.getElementById("count").value = count; 
}

function reset() {
  document.getElementById("count").value = 0; 
}
