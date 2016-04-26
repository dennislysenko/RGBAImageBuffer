# RGBAImageBuffer

Get the UIColor of any pixel in a UIImage or CGImage relatively painlessly in Swift. Based heavily on [this MIT-licensed snippet](https://gist.github.com/PaulSolt/739132).

## installation

CocoaPods: `pod 'RGBAImageBuffer'`

You can also simply copy [RGBAImageBuffer.swift](../master/RGBAImageBuffer/RGBAImageBuffer.swift) into your project.

## usage

```swift
let image = UIImage(named: "sample_photo")!

if let rgbaBuffer = RGBAImageBuffer(image: image.CGImage) {
  // when you want to get the color at a specific (x, y) location:
  if let color = rgbaBuffer[x, y] {
    // do something with the color :)
  }
} else {
  // probably a memory error, or the image was not backed by a CGImage. handle error appropriately
}
```

## why?

Because normally you have to interface with raw memory to accomplish this, and no one wants to do that. This makes it a (relatively) safe nullable subscript, rather than (relatively) unsafe pointer math.

## danger! retina devices

When using UIImage, remember that the UIImage's `size` property is **scaled and therefore will NOT match the width/height of the RGB pixel buffer.**

In plain(-er) English: say you have a retina, `@2x` image that's 640x640. If you make a UIImage from this on a device with a retina screen, it will have `size` = (320, 320) and `scale` = 2. However, if you make a `RGBAImageBuffer` from it, the `RGBAImageBuffer` will have `width` and `height` = 640, the same as the original image resource.

Moral of the story: retina devices complicate pixel-exact operations on images. Send me a Github message if you need help figuring the above out (and please submit a pull request if you have a better explanation. that'd be lovely).
