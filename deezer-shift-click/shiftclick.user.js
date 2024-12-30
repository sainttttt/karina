var lastClicked;
var currentClicked;

async function clickHandler(e) {

  var x = e.x
  var parentRow = x.parentElement.parentElement.parentElement.parentElement.parentElement

  currentClicked = parseInt(parentRow.getAttribute("aria-rowindex"))

  // console.log(lastClicked)
  var dir = 1
  if (e.shiftKey) {
    console.log('shift clicked')
    console.log({lastClicked})
    if (currentClicked > lastClicked) {
      dir = -1
    }
    if (lastClicked) {
      var startNumber = currentClicked
      var endNumber = lastClicked
      for (var j = startNumber; j != endNumber; j = j + dir) {
        console.log(j)
        var w = await clickElement(j, dir)
        console.log(w)
        console.log('finished')
        // break
      }
    } else {
      x.click()
    }
  }

  lastClicked = currentClicked
}

function addHandlers(p) {
  p.querySelectorAll(".chakra-checkbox__input").forEach((x) => {
    var elemToClick = x.parentElement
    elemToClick.x = x
    elemToClick.addEventListener("click", clickHandler)
  })
}

function clickElement(el, dir) {
  return new Promise((resolve, reject) => {
    //upload the file, then call the callback with the location of the file
    var i = 0;
    var ce = () => {
      console.log("here")
      var p = document.querySelector(`div[aria-rowindex="${el}"]`)
      if (!p) {
        window.scrollBy(0, 300 * dir);
        console.log('scrolling')
        i += 1
        if (i < 100) {
          setTimeout(ce, 1)
        } else {
          resolve("cat")
        }
      } else {
        p.querySelector(".chakra-checkbox__input").click()
        resolve("dog")
      }
    }
    ce()
  })
}

function inject() {

  addHandlers(document)

  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      for(var i = 0; i < mutation.addedNodes.length; i++)
      addHandlers(mutation.addedNodes[i])
    })
  });

  var el2 = document.querySelector('.JR0qJ')
  if (el2) {
    observer.observe(el2.parentElement, {
      childList: true
    });
  }

}


setTimeout(inject, 5000);

document.addEventListener('readystatechange', event => {

    // When HTML/DOM elements are ready:
  if (event.target.readyState === "interactive") {   //does same as:  ..addEventListener("DOMContentLoaded"..
  }

    // When window loaded ( external resources are loaded too- `css`,`src`, etc...)
  if (event.target.readyState === "complete") {

  }
});
