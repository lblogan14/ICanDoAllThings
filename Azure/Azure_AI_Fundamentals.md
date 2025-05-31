# Azure AI Fundamentals

Azure AI services are a portfolio of AI capabilities that unlock automation for workloads in language, vision, information extraction, content generation, and much more.

For example, 
- Azure OpenAI in Foundry Models provides access to powerful, cutting-edge, generative AI models for application development. 
- Azure AI Foundry Content Safety service can be used to detect harmful content within text or images, including violent or hateful content, and report on its severity. 
- Azure AI Language service can be used to summarize text, classify information, or extract key phrases. 
- Azure AI Speech service provides powerful speech to text and text to speech capabilities, allowing speech to be accurately transcribed into text, or text to natural sounding voice audio.

Developers can access AI services through REST APIs, client libraries, or integrate them with tools such as Logic Apps and Power Automate. APIs are application programming interfaces that define the information that is required for one component to use the services of the other. APIs enable software components to communicate, so one side can be updated without stopping the other from working.

Azure AI services are cloud-based and accessed through an Azure resource. This means that they're managed in the same way as other Azure services, such as platform as a service (PaaS), infrastructure as a service (IaaS), or a managed database service.

Azure AI services are cloud-based, and like all Azure services we need to create a resource to use them. There are two types of AI service resources:
- **Multi-service resource** - a resource created in the Azure portal that provides access to multiple AI services with a single key and endpoint. Use the resource **Azure AI services** when we need several AI services or explore AI capabilities. When we use an Azure AI services resource, all our AI services are billed together.
- **Single-service resource** - a resource created in the Azure portal that provides access to a single Azure AI service, such as Speech, Vision, Language, etc. Each Azure AI service has a unique key and endpoint.


Azure AI Foundry Portal is a unified platform and visual interface for enterprise AI operations, model builders, and application development. Azure AI Foundry portal combines access to multiple Azure AI services and generative AI models into one user interface.

## Authentication for Azure AI Services
The endpoint describes how to reach the AI service resource instance that you want to use, in a similar way to the way a URL identifies a web site. When we view the endpoint for our resource, it will look something like:
```
https://<resource-name>.cognitiveservices.azure.com/
```
The resource key protects the privacy of our resource. To ensure this is always secure, the key can be changed periodically. We can view the endpoint and key in the Azure portal under Resource Management and Keys and Endpoint.

When we write code to access the AI service, the keys and endpoint must be included in the authentication header. The authentication header sends an authorization key to the service to confirm that the application can use the resource.