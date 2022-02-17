#Wb styles
https://theloop.worldbank.org/typography/heading

# Colors
https://colorhunt.co/

# Selectors

## mulitple selectors
 slector, selector2, selector3 {
    color: red;
 }

## Hierarchical selectors
Notice that there is space between
Parent child{

}

## Combined Selectors
div that has a Class all the selectors must be within the same box
div.class{


}

# CSS

Deafault broweser CSS: https://www.w3schools.com/cssref/css_default_values.asp
Pesticide extension useful to inspect
useful for CSS commands: https://devdocs.io/css/
Useful for CSS tricks https://developer.mozilla.org/
Properties css: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Properties_Reference

## Internal CSS


In the HTML head:

<style>
  selector{
    property: value;
  }

</style>


## External CSS

In the HTML head:
(careful with the path!)
<link rel="stylesheet" href="/css/file.css">

## Selectors
tags have predefined values
Ids override tags
Class override tags
Ids override Class

## Sudo clases
Are based on the satet and have a : before

img:hover{

      property: value;
}

#Box model

* Heigth and width to fit the content
* Padding: space between the content and edge of Box (within)
* The padding increases the size of the Box
* Margin is space between other boxes (around)
* width + border-width + padding

# Display
* **Block**: (h1, p, divs, forms, lists) take the whole width of the screen. YOU CAN CHANGE THE WIDTH
* **Inline**: (span, img, a) Only takes as much space as it needs to: are stacked on the same line until there is space but YOU CANNOT CHANGE THE WIDTH
* **inline-block**: can change width and are stacked on the same line.
* **None**: gets rid of the element (as it does not exist, "visibility" makes it trasnparent but the position remains)

element{
  display: inline;

}

# Positioning
1. Content is everything- it determines the size of the boxes
2. Order comes from code (determined by HTML)
3. Children sit on parents

* **Static** -- default flow
* **Relative** -- position relative to ITS original position (top, left, right, bottom). When an element is moved, it doesnt affect the other boxes' position (leave its ghost) "give me 20px space on the top! top: 20px"
* **Absolute**: relative to its parent! adding a margin to its parent element. And it affects the flow of the other boxes! no longer a ghost!
* **Fixed** : it gets fixs to its position (good for nav bar or side bar...)

element{

  position: relative;
  top: 10px; (this will move the box 10px down to its original position)
}

element{

  position: absolute;
  top: 10px; (this will create a margin of 10px from the parent box)
}

The perfect container for a position absolute is a relative one. This is because the absolute position will be relative to the container. If the parent doesnt have a relative position, the absolute of the child will be relative to the body.

## Center

* text-align: center; in the parent container
* margin: 0 auto; --- center horizontally

## Justify row to the left
<div class="row justify-content-end">

##Justify column vertically
<div class="col-6 align-self-center">

# media

950px or less
@media (max-width:950px){

  change something
}


Text align center inside the parent that doesnt have a width set!. if it has a width set, use the auto margin.
# Favicon
https://favicon.io/favicon-converter/
<link rel ="icon" href="path/file.png?v=2?">

# Lorem ipsu
https://loremipsum.io/
https://www.lipsum.com/
