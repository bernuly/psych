#The diagram functions 

#The diagram function is the generic function (actually empty) that allows a clearer help file
#the entire set of functions for diagramming are all prefixed as dia. 
"diagram" <- function() {}


"dia.rect" <- function(x, y = NULL, labels =NULL,  cex = 1, xlim=c(0,1),ylim=c(0,1),...) {
     text(x=x, y = y, labels = labels,  cex = cex,   ...)
      xrange = (xlim[2] - xlim[1])
    yrange = (ylim[2] - ylim[1])
    xs <- .10 * xrange
    ys <- .10 * xrange
     #len <- max(nchar(labels)*cex*.2/2,cex*.25)*xs
     len <- max(strwidth(labels),strwidth("abc"))/1.8
     vert <- min(cex*.3 * ys,.3)
     rect(x-len,y-vert,x+len,y+vert)
     left <- c(x-len,y)
     right <- c(x+len,y)
     top <- c(x,y+vert)
     bottom <- c(x,y-vert)
     radius <- sqrt(len^2+vert^2)
    dia.rect <- list(left=left,right=right,top=top,bottom=bottom,center=c(x,y),radius=radius)
     }
     
 "dia.ellipse" <-  function(x, y = NULL, labels = NULL, cex = 1,e.size=.05,xlim=c(0,1),ylim=c(0,1), ...) {
     text(x=x, y = y, labels = labels,cex = cex, ...)
     len <- max(strwidth(labels),strwidth("abc"))/1.6
     #vert <- cex*.3
     xs <- dia.ellipse1(x,y,xlim=xlim,ylim=ylim,e.size=e.size*len,...)
     left <- c(x-xs,y)
     right <- c(x+xs,y)
     top <- c(x,y+xs)
     bottom <- c(x,y-xs)
     center <- c(x,y)
    dia.ellipse <- list(left=left,right=right,top=top,bottom=bottom,center=center,radius=xs)
     }
          
     
"dia.ellipse1" <-    function (x,y,e.size=.05,xlim=c(0,1),ylim=c(0,1),...) { 
#code adapted from John Fox
    segments=51
    angles <- (0:segments) * 2 * pi/segments
    unit.circle <- cbind(cos(angles), sin(angles))
    xrange = (xlim[2] - xlim[1])
    yrange = (ylim[2] - ylim[1])
    xs <- e.size * xrange
    #ys <- e.size * yrange
    ellipse <- unit.circle 
    ellipse[,1] <- ellipse[,1]*xs + x
    ellipse[,2] <- ellipse[,2]*xs + y  #ys?
    lines(ellipse, ...)
    return(xs)
}
       
"dia.triangle" <- function(x, y = NULL, labels =NULL,  cex = 1, xlim=c(0,1),ylim=c(0,1),...) {
     text(x=x, y = y, labels = labels,  cex = cex,   ...)
    STRETCH=.25
      xrange = (xlim[2] - xlim[1])
    yrange = (ylim[2] - ylim[1])
    xs <- .10 * xrange
    ys <- .10 * xrange
     #len <- max(nchar(labels)*cex*.2/2,cex*.25)*xs
     len <- max(strwidth(labels)*.7,strwidth("abc"))
     #vert <- min(cex*.3 * ys,.3)
     vert <- .7*len
     left <- c(x-len/2,y+vert/2-STRETCH/2)
     right <- c(x+len/2,y+vert/2-STRETCH/2)
     top <- c(x,y+vert)
    # bottom <- c(x,y-vert/2)
    bottom <- c(x,y-vert*STRETCH)
     xs <- c(x-len,x+len,x)
     ys <- c(y-vert*STRETCH,y-vert*STRETCH,y+vert)
     #ys <- c(y,y,y+vert)
     polygon(xs,ys)
     radius <- sqrt(len^2+vert^2)
    dia.rect <- list(left=left,right=right,top=top,bottom=bottom,center=c(x,y),radius=radius)
     }
       
"dia.arrow" <- function(from,to,labels=NULL,scale=1,cex=1,...) {
    radius1 <- radius2 <- 0
 	if(is.list(from)) {if(!is.null(from$radius)) {radius1 <- from$radius
 	        radius2 <- 0
    		from <- from$center}}
       if(is.list(to)) {if(!is.null(to$radius)) {radius2<- to$radius 
       			to <- to$center}}
       theta <- atan((from[2] - to[2])/(from[1] - to[1]))
        x <- (from[1] + to[1])/2
        y <- (from[2] + to[2])/2
        if(is.null(labels)) {h.size <- 0 } else{ h.size <- nchar(labels)*cex*.4}
        if(is.null(labels)) {v.size <- 0 } else{ v.size <- cex * .2}
       
        if(from[1] <  to[1] ) {h.size <- -h.size
                               radius1 <- -radius1
                               radius2 <- -radius2}
        x0 <- from[1] - cos(theta) * radius1
        y0 <- from[2] - sin(theta) * radius1
        xr <- x + h.size * cos(theta)* v.size
        xl <- x - h.size * cos(theta)* v.size
        yr <- y + v.size * sin(theta) * h.size 
        yl <- y - v.size * sin(theta)  *h.size
        xe <- to[1] + cos(theta) * radius2
        ye <- to[2] + sin(theta) * radius2
       if(!is.null(labels))  text(x,y,labels,cex=cex,...)
        arrows(x0,y0,xr,yr, length = 0, angle = 30, code = 2, ...)
        arrows(xl,yl,xe,ye, length = 0.1*scale, angle = 30, code = 2,...)
       }
       
       
"dia.curve" <- function(from,to,labels=NULL,scale=1,...) {
   #arrow at beginning and end of curve
   #first, figure out the boundaries of the curve
    radius1 <- radius2 <- 0
 	if(is.list(from)) {if(!is.null(from$radius)) {radius1 <- from$radius
 	        radius2 <- 0
    		from <- from$center}}
       if(is.list(to)) {if(!is.null(to$radius)) {radius2<- to$radius 
       			to <- to$center}}
       			
       	theta <- atan((from[2] - to[2])/(from[1] - to[1]))
        if((from[1] <  to[1])) {
                             radius1 <- -radius1
                           radius2 <- -radius2}
       	from[1] <-  from[1] - cos(theta) * radius1
       	from[2] <-  from[2] - sin(theta) * radius1
       	to[1] <- to[1] + cos(theta) * radius2
        to[2] <- to[2] + sin(theta) * radius2
        
      
    n <- 40
    scale <- .8 * scale
     if(is.null(labels)) {shift<- 0} else {shift <- 4}
    if(abs(from[1] - to[1]) < abs(from[2] - to[2]))  { #is it primarily up and down or left to right?
   		 x <- c(from[1],(from[1]+to[1])/2+scale,to[1])
   		 y <- c(from[2],(from[2]+to[2])/2,to[2])
   		sp <- spline(y,x,n)
 	 	lines(sp$y[1:(n/2-shift)],sp$x[1:(n/2-shift)])
     	lines(sp$y[(n/2+shift):n],sp$x[(n/2+shift):n])
     	arrows(sp$y[3],sp$x[3],sp$y[1],sp$x[1],length = .5*abs(sp$x[2]-sp$x[1]))
     	arrows(sp$y[n-3],sp$x[n-3],sp$y[n],sp$x[n],length = .5*abs(sp$x[2]-sp$x[1]))
  		text(sp$y[n/2],sp$x[n/2],labels,...)  
  		} else {
  		 x <- c(from[1],(from[1]+to[1])/2,to[1])
   		 y <- c(from[2],(from[2]+to[2])/2+ scale,to[2])
   		sp <- spline(x,y,n)
 	 	lines(sp$x[1:(n/2-shift)],sp$y[1:(n/2-shift)])
     	lines(sp$x[(n/2+shift):n],sp$y[(n/2+shift):n])
     	arrows(sp$x[3],sp$y[3],sp$x[1],sp$y[1],length = 1*abs(sp$y[2]-sp$y[1]))
     	arrows(sp$x[n-3],sp$y[n-3],sp$x[n],sp$y[n],length = 1*abs(sp$y[2]-sp$y[1]))
  		text(sp$x[n/2],sp$y[n/2],labels,...)  
  		}
}

"dia.curved.arrow" <- function(from,to,labels=NULL,scale=1,...) {
     #note that the splines seem to go from left to right no matter what!
     #first determine whether to add or subtract the radius
     
      radius1 <- radius2 <- 0
 	if(is.list(from)) {if(!is.null(from$radius)) {radius1 <- from$radius
 	        radius2 <- 0
    		from <- from$center}}
       if(is.list(to)) {if(!is.null(to$radius)) {radius2<- to$radius 
       			to <- to$center}}
       			
       	theta <- atan((from[2] - to[2])/(from[1] - to[1]))
       	if( from[1] < to[1] ) {
                             radius1 <- -radius1
                             radius2 <- -radius2}
       	from[1] <-  from[1] - cos(theta) * radius1
       	from[2] <-  from[2] - sin(theta) * radius1
       	to[1] <- to[1] + cos(theta) * radius2
        to[2] <- to[2] + sin(theta) * radius2
    
     scale <- .8 * scale
      n <- 40
     if(is.null(labels)) {shift<- 0} else {shift <- 4}
    if(abs(from[1] - to[1]) < abs(from[2] - to[2]))  { #is it primarily up and down or left to right?
   		 x <- c(from[1],(from[1]+to[1])/2+scale,to[1])
   		 y <- c(from[2],(from[2]+to[2])/2,to[2])
   		sp <- spline(y,x,n)
 	 	lines(sp$y[1:(n/2-shift)],sp$x[1:(n/2-shift)])
     	lines(sp$y[(n/2+shift):n],sp$x[(n/2+shift):n])
     	arrows(sp$y[3],sp$x[3],sp$y[1],sp$x[1],length = .5*abs(sp$x[2]-sp$x[1]))
     	arrows(sp$y[n-3],sp$x[n-3],sp$y[n],sp$x[n],length = .5*abs(sp$x[2]-sp$x[1]))
  		text(sp$y[n/2],sp$x[n/2],labels,...)  
  		} else {
  		 x <- c(from[1],(from[1]+to[1])/2,to[1])
   		 y <- c(from[2],(from[2]+to[2])/2+ scale,to[2])
   		sp <- spline(x,y,n)
 	 	lines(sp$x[1:(n/2-shift)],sp$y[1:(n/2-shift)])
     	lines(sp$x[(n/2+shift):n],sp$y[(n/2+shift):n])
     	if((from[1] > to[1] ) ) {arrows(sp$x[3],sp$y[3],sp$x[1],sp$y[1],length = 1*abs(sp$y[2]-sp$y[1])) } else {
     	arrows(sp$x[n-3],sp$y[n-3],sp$x[n],sp$y[n],length = 1*abs(sp$y[2]-sp$y[1]))}
  		text(sp$x[n/2],sp$y[n/2],labels,...)  
  		}
}


 "dia.self" <- function(location,labels=NULL,scale=.8,side=2,...) {
   n <- 20
if(side %%2 > 0) {scale <- scale*(location$right[1] - location$left[1]) } else {scale <- scale*(location$top[2] - location$bottom[2]) }
 # scale <- scale *.8
 if (side==1) {x <- c(location$bottom[1]-scale/2,location$bottom[1],location$bottom[1]+scale/2)
               y <- c(location$bottom[2],location$bottom[2]-scale,location$bottom[2])
               sp <- spline(x,y,n=20)
               lines(sp$x,sp$y)
               arrows(sp$x[3],sp$y[3],sp$x[1],sp$y[1],length = 2*abs(sp$x[3]-sp$x[1]))
     	       arrows(sp$x[n-3],sp$y[n-3],sp$x[n],sp$y[n],length = 2*abs(sp$x[3]-sp$x[1]))}
 if (side==2) {x <- c(location$left[1],location$left[1]-scale,location$left[1])
               y <- c(location$left[2]-scale/2,location$left[2],location$left[2]+scale/2)
               sp <- spline(y,x,n=20)
               lines(sp$y,sp$x)
               arrows(sp$y[3],sp$x[3],sp$y[1],sp$x[1],length = 2*abs(sp$x[2]-sp$x[1]))
     	      arrows(sp$y[n-3],sp$x[n-3],sp$y[n],sp$x[n],length = 2*abs(sp$x[2]-sp$x[1]))}
 if (side==3) {x <- c(location$top[1]-scale/2,location$top[1],location$top[1]+scale/2)
               y <- c(location$top[2],location$top[2]+scale,location$top[2])
               sp <- spline(x,y,n=20)
                 lines(sp$x,sp$y)
                 arrows(sp$x[3],sp$y[3],sp$x[1],sp$y[1],length = 2*abs(sp$x[3]-sp$x[1]))
     	         arrows(sp$x[n-3],sp$y[n-3],sp$x[n],sp$y[n],length = 2*abs(sp$x[3]-sp$x[1]))}
 if (side==4) {x <- c(location$right[1],location$right[1]+scale,location$right[1])
               y <- c(location$right[2]-scale/2,location$right[2],location$right[2]+scale/2)
               sp <- spline(y,x,n=20)
              
               lines(sp$y,sp$x)
               arrows(sp$y[3],sp$x[3],sp$y[1],sp$x[1],length =2* abs(sp$x[3]-sp$x[1]))
     	arrows(sp$y[n-3],sp$x[n-3],sp$y[n],sp$x[n],length = 2*abs(sp$x[3]-sp$x[1]))}
               
    }
    
  "dia.shape" <- function(x, y = NULL, labels = NULL, cex = 1,e.size=.05,xlim=c(0,1),ylim=c(0,1),shape=1, ...) {
     if (shape==1) {dia.rect(x, y = NULL, labels =NULL,    cex = 1, xlim=c(0,1),ylim=c(0,1),...) }
     if (shape==2) {dia.ellipse(x, y = NULL, labels = NULL, cex = 1,e.size=.05,xlim=c(0,1),ylim=c(0,1), ...)}
     if (shape==3) {dia.triangle(x, y = NULL, labels =NULL,  cex = 1, xlim=c(0,1),ylim=c(0,1),...)}
     }
     
     