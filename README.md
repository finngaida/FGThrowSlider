FGThrowSlider
=============

iOS drop-in control giving you the iOS 7.1 brightness/volume style slider with a dynamic fadeout animation. 

Simply copy over the FGThrowSlider.h and FGThrowSlider.m files into your project, create a new instance in the delegate like so:  
  `FGThrowSlider *slider = [FGThrowSlider sliderWithFrame:CGRectMake(50, 300, 200, 50) andDelegate:self];`  
add it to your view:  
  `[view addSubview:slider];`  
and recieve updates at:
  `- (void)slider:(FGThrowSlider *)slider changedValue:(CGFloat)value`
  
Feel free to use it in your projects and let me know of any ideas, requests, stuff.
