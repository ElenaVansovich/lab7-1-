//
//  ViewController.m
//  Painting
//
//  Created by Lena Vansovich on 4/25/16.
//  Copyright (c) 2016 Lena Vansovich. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *canvas;
@property (weak, nonatomic) IBOutlet UIButton *redColorButton;
@property (weak, nonatomic) IBOutlet UIButton *greenColorButton;
@property (weak, nonatomic) IBOutlet UIButton *blueColorButton;
@property (weak, nonatomic) IBOutlet UIPickerView *widthPickerView;
@property (weak, nonatomic) IBOutlet UIButton *roundBrushButton;
@property (weak, nonatomic) IBOutlet UIButton *squareBrushButton;
@property CGPoint lastPoint;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) NSArray *brushSizes;
@property (nonatomic) NSString *lineCap;
@end

@implementation ViewController

- (IBAction)changeColorForRed:(id)sender {
    _lineColor = [UIColor redColor];
}
- (IBAction)changeColorForGreen:(id)sender {
    _lineColor = [UIColor greenColor];
}
- (IBAction)changeColorForBlue:(id)sender {
    _lineColor = [UIColor blueColor];
}
- (IBAction)changeBrushForRound:(id)sender {
    _lineCap = @"Round";
}
- (IBAction)changeBrushForSquare:(id)sender {
    _lineCap = @"Square";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.canvas = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.canvas.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.canvas];
    
    self.widthPickerView.delegate = self;
    self.widthPickerView.dataSource = self;
    
    _lineColor = [UIColor blackColor];

    self.brushSizes = @[@"3",@"5",@"7",@"10",@"15"];
    self.lineWidth = 3.f;
    self.lineCap = @"Round";
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    [self setLastPoint:[touch locationInView:self.view]];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,
                                 self.view.frame.size.height);
    [[[self canvas] image] drawInRect:drawRect];
    if([_lineCap isEqual:@"Round"]){
        CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound);
    }
    if([_lineCap isEqual: @"Square"]){
        CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapSquare);
    }
    
    if ([_lineColor isEqual:[UIColor redColor]]) {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0f, 0.0f, 0.0f, 1.0f);
    }
    if ([_lineColor isEqual:[UIColor greenColor]]) {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0f, 1.0f, 0.0f, 1.0f);
    }
    if ([_lineColor isEqual:[UIColor blueColor]]) {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0f, 0.0f, 1.0f, 1.0f);
    }
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.lineWidth);
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x,  _lastPoint.y); 
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    [[self canvas] setImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    _lastPoint = currentPoint;
}

#pragma mark - UIPickerView Delegate, DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.brushSizes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.brushSizes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.lineWidth = [self.brushSizes[row] floatValue];
}

@end
