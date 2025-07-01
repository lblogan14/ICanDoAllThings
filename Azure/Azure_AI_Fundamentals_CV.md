# Azure AI Fundamentals - Computer Vision
The *multi-modal models*, such as Microsoft's *Florence* model, are trained using a large volume of captioned images, with no fixed labels. An image encoder extracts features from images based on pixel values and combines them with text embeddings created by a language encoder. The overall model encapsulates relationships between natural language token embeddings and image features.

Florence is an example of a *foundation model*. IT is a pretrained general model on which we can build mutiple *adaptive models* for specialist tasks.

## Azure AI Vision
Azure AI Vision service provides prebuilt and customizable CV models that are based on the Florence foundation model and provide various powerful capabilities.

To use Azure AI Vision, we need to create a resource for it in our Azure subscription:
- **Azure AI Vision**: a specific resource for the Azure AI Vision service. Use this one if we do not intend to use any other Azure AI services.
- **Azure AI services**: a general resource that includes Azure AI Vision along with many other Azure AI services; such as Azure AI Language, Azure AI Custom Vision, and others. Use this resource type of we plan to use multiple AI services and want to simplify administration and development.


Azure AI Vision supports
- Optical Character Recognition (OCR): extract text from images
- Generating captions and descriptions for images
- Detection of common objects in images
- Tagging visual features in images

We can access and test Azure AI Vision capabilities in Azure AI Foundry, a unified platform for enterprise AI operatons, model builders, and application development.


If the built-in models don't meet our needs, we can use the service to train a custom model for *image classification* or *object detection*. Azure AI Vision builds custom models on the pre-trained foundation model.

## Facial Recognition
Azure provides multiple Azure AI services that we can use to detect and analyze faces:
- **Azure AI Vision**: offers face detection and some basic face analysis, such as returning the boudning box coordinates around an image.
- **Azure AI Video Indexer**: used to detect and identify faces in videos.
- **Azure AI Face**: offers pre-built algorithms that can detect, recognize, and analyze faces.

### Azure AI Face
Azure AI Face service can return the retangle coordinates for any human faces that are found in an image, as well as
- accessories - whether the given face has accessories such as headwear, glasses, and mask, with confidence score between 0 and 1 for each accessory
- blur - how blurred the face is, which can be an indication of how likely the face is to be the main focus on the image
- exposure - whether the image is underexposed or overexposed. This applies to the face in the image, not the whole image
- glasses - whether the person is wearing glasses
- head pose - the face orientation in a 3D space
- mask - whether the person is wearing a mask
- noise - visual noise in the image.
- occlusion - whether there are any objects blocking the face in the image
- quality for recognition - a rating of high, medium or low that reflects if the image is of sufficient quality to attempt face recognition on

To improve the accuracy of face detection, consider the following:
- image format - JPEG, PNG, GIF, and BMP
- file size - 6 MB or smaller
- face size range - from 36x36 pixels up to 4096x4096 pixels
- other issues - extreme face angles, extreme lighting, or occlusion