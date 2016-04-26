# RGBImageBuffer

Access raw RGB data from a UIImage painlessly in Swift. Based heavily on [this MIT-licensed snippet](https://gist.github.com/PaulSolt/739132).

# usage

For now, I don't have the time to upload this as a pod. You can simply copy [RGBImageBuffer.swift](../blob/master/RGBImageBuffer/RGBImageBuffer.swift) into your project and use it with a UIImage:

```swift
let image = UIImage(named: "sample_photo")!

let rgbBuffer = RGBImageBuffer(image: image)

// when you want to get the color at a specific (x, y) location:
if let color = rgbBuffer[x, y] {
  // do something with the color :)
}
```

# why?

Because normally you have to interface with raw memory to accomplish this, and no one wants to do that. This makes it a (relatively) safe nullable subscript, rather than (relatively) unsafe pointer math.

# danger! retina devices

When using UIImage, remember that the UIImage's `size` property is **scaled and therefore will NOT match the width/height of the RGB pixel buffer.**

In plain(-er) English: say you have an @2x image that's 640x640. If you make a UIImage from this, it will have `size` = (320, 320) and `scale` = 2. However, if you make a `RGBImageBuffer` from it, the `RGBImageBuffer` will have `width` and `height` = 640, the same as the original image resource.

Moral of the story: retina devices complicate pixel-exact operations on images. Send me a Github message if you need help figuring the above out (and please submit a pull request if you have a better explanation. that'd be lovely).