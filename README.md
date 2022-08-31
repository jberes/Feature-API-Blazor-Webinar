# Watch the Webinar - Create & Deploy a .NET 6 Minimal Web API from SQL Server Data

To watch the end-to-end video of creating this entire solution, watch this YouTube video or follow the step by step below (note, you really should watch the video for the full picture).

https://www.youtube.com/watch?v=d9X0Q5iY8OE

![](https://github.com/jberes/Feature-API-Blazor-Webinar/blob/master/Images/0-WatchYouTube.png?raw=true)



## Creating a CRUD Web API with Minimal API

To create the Web API, you'll be using SQL Server Express as the database. To install SQL Server Express, download from here:

https://www.microsoft.com/en-us/Download/details.aspx?id=101064

One you install, the next step is to install the SQL Server Management Studio. This is your IDE to add databases, create tables, views, queries, etc. Get SQL Server Management Studio from here:

https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16

Once installed, open SQL Server Management Studio, and connect to your instance of SqlExpress (most likely '.\sqlexpress'), then click the New Query button, and run the SQL Script located here:

https://github.com/jberes/Feature-API-Blazor-Webinar/blob/master/FeaturesDbScript.sql

This will create the database, tables and insert the data into the created tables so you can build your Web API and so you have data to experiment with.

**You are now ready to create your .NET Core Web API app!**

## Get Started


Create new ASP.NET Core Web API project called **FeaturesApi**

![](https://github.com/jberes/Feature-API-Blazor-Webinar/blob/master/Images/3-CreateNewProjectFinish.png?raw=true)


Once the project is created, right-click on the Project name and select Manage Nuget Packages, and add the following packages to your solution:

* Microsoft EntityFrameworkCore

* Microsoft.EntityFrameworkCore .SqlServer

* Microsoft.EntityFrameworkCore.Design


![](https://github.com/jberes/Feature-API-Blazor-Webinar/blob/master/Images/4-AddNugetPackages.png?raw=true)

Next, open the Package Manager console, and install the dotnet EF Tools:

`dotnet tool install --global dotnet-ef --ignore-failed-sources`

Note- use `ignore-failed-sources` if you have more than one source , especially if you are using any local Nuget feeds. If you don't include this, and the package can't be found, the install will fail.

Next, right click on your project name and select Manage User Secrets from the menu. In secrets.json add your connection string

```xml
{
  "ConnectionStrings": {
    "LocalConnection" : "server=.\\sqlexpress;database=Features;trusted_connection=true;"
  }
}
```
In the Package Manager Console, create your models and db context using the dotnet-ef CLI tools that you installed.  To see a complete list of the CLI commands, check out this link: https://docs.microsoft.com/en-us/ef/core/cli/dotnet

```C#
dotnet ef dbcontext scaffold Name=ConnectionStrings:LocalConnection Microsoft.EntityFrameworkCore.SqlServer -o Models --force
```

In Program.cs, before the line that contains:

```C#
var app = builder.Build();
```

add the following to add the DB Context to your build configuration:

```C#
builder.Services.AddDbContext<FeaturesContext>(options =>
options.UseSqlServer(builder.Configuration.GetConnectionString("LocalConnection")));
```

then add a CORS policy so you can access the Service from your local app and from App Builder:

```// Add Cors
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
      builder => builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()
    );
});
```

In the IsDevelopment check, add the newly created CORS policy as highlighted here:

```// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseCors("AllowAll");
    app.UseSwagger();
    app.UseSwaggerUI();
}
```

## Add HTTP Request Handlers

Add the following HTTP handlers in **Program.cs** after **app.UseHttpDirection**.

```
app.MapGet("/", () => "Welcome to the Features Web API");
```

#### Get All Features

```c#
    app.MapGet("/features", async (FeaturesContext context) =>
    await context.Features.ToListAsync());
```

#### Get Features by Feature Id

```c#
app.MapGet("/features/{id}", async (FeaturesContext context, int id) =>
{
    var feature = await context.VwFeatureProducts
        .Where(f => f.FeatureId == id).ToListAsync();
    return feature;
});
```

#### Add New Feature

```
app.MapPost("/features", async (FeaturesContext context,
        [FromBody] Feature feature) =>
{
    // You can use this to just save the entire object in the Post
    //feature.FeatureId = 0;
    //context.Features.Add(feature);
    //await context.SaveChangesAsync();

    //// Or you can set each field independently 
    var newFeature = new Feature()
    {
        Title = feature.Title,
        Description = feature.Description,
        RequestorEmail = feature.RequestorEmail,
        ProductId = feature.ProductId
    };
    await context.Features.AddAsync(newFeature);
    await context.SaveChangesAsync();
    return Results.Ok(newFeature);
});
```

#### Update Feature

```
app.MapPut("/features/", async (FeaturesContext context,
        [FromBody] Feature feature) =>
{
    // Find the feature to update otherwise send an error back
    var dbFeatureRequest = await context.Features.FindAsync(feature.FeatureId);
    if (dbFeatureRequest == null)
        return Results.NotFound("Feature Request #" + feature.FeatureId + " Not Found");

    dbFeatureRequest.ProductId = feature.ProductId;
    dbFeatureRequest.Title = feature.Title;
    dbFeatureRequest.Description = feature.Description;
    dbFeatureRequest.RequestorEmail = feature.RequestorEmail;
    // Save to the Database
    await context.SaveChangesAsync();
    return Results.Ok(dbFeatureRequest);
});
```

#### Delete Feature

```
app.MapDelete("features/{id}", async (FeaturesContext context, int id) =>
{
    var dbRequest = await context.Features.FindAsync(id);
    if (dbRequest == null)
        return Results.NotFound("Feature #" + id + " Not Found");
        
    context.Features.Remove(dbRequest);
    await context.SaveChangesAsync();
    return Results.Ok(dbRequest);
});
```

Your Web API is complete!  Hit Run, and you should see the Swagger generated page with your APIs.

![](https://github.com/jberes/Feature-API-Blazor-Webinar/blob/master/Images/6-SwaggerGen.png?raw=true)

Leave this app running, you'll need to access your data from the Swagger URL - https://localhost:7229

## Create App Builder App

To sign in to App Builder or to start a trial, go here:

https://appbuilder.indigo.design/ or https://www.infragistics.com/products/appbuilder

The next step is to create the client app in Blazor.  To do this step-by-step, watch the video linked above, otherwise, download the app starter from here:

https://github.com/jberes/Feature-API-Blazor-Webinar/blob/master/FeaturesApp_blazor-wasm.zip?raw=true

Unzip and open this project in Visual Studio.

To get the app to work in a nice Master-Detail format, we are going to make a few changes to the code:

1. Add a **Click** event to the **List** control so when an item it clicked, the text boxes are loaded with the correct data.  This will include adding an **onClick** event on the control, and a new function called **ListSectionChanged**, which will call the HTTP service and pass the **FeatureId** of the selected list item.
2. Update the page initialize to get the first item in the List control, and pass that **FeatureId** to the same HTTP service call in step 
3. Update the Service call to accept and use the parameter passed from the client form.
4. Update the Text Inputs that were created in App Builder to show the correct data every time a List item is clicked.

## Update the Client App

1. As you recall in the .NET Core Service, we need to pass a parameter to get a specific **Feature** by **FeatureId**.  To enable this function to accept the parameter, change the `GetFeaturesId` in the **FeaturesAlphaService.cs** file to include the parameter as well as passing the parameter to the HTTP service instead of the hard-coded value.

   ```        C#
   public async Task<FeaturesIdType[]?> GetFeaturesId(double featuresIdId)
   {
       //var featuresIdId = "1";
       return await this.http.GetFromJsonAsync<FeaturesIdType[]>
           ($"https://localhost:7089/features/{featuresIdId}");
   }
   ```

   

2. Update the `OnItitializedAsync` event to pass the first item loaded in the List control to the `GetFeaturesId` function.

   ```c#
       protected override async Task OnInitializedAsync()
       {
           featuresFeatures = await this.featuresService.GetFeatures() ?? featuresFeatures;
           
           // this is the line that changes
           featuresFeaturesId = await this.featuresService
                   .GetFeaturesId(featuresFeatures.First().FeatureId.Value) 
                   ?? featuresFeaturesId;
       }
   ```

3. In the **MasterView.razor**, add the following the to the List Item click event:

   ```c#
   <IgbListItem @onclick="(() => ListSelectionChanged(item))">
   ```

4. Update the Feature Details section to only a single foreach, and copy the line a few times and paste it and change the `@bind-value` and Label to match the fields that you'd like to show.

```         c#
@foreach (var item in featuresFeaturesId)
{
    <IgbInput @bind-Value="@item.Title" Label="Label/Placeholder" Placeholder="Title" Outlined="true" class="input" view-2-scope></IgbInput>
    <IgbInput @bind-Value="@item.Product" Label="Label/Placeholder" Placeholder="Product" Outlined="true" class="input" view-2-scope></IgbInput>
    <IgbInput @bind-Value="@item.Description" Label="Label/Placeholder" Placeholder="Description" Outlined="true" class="input" view-2-scope></IgbInput>
    <IgbInput @bind-Value="@item.DateAdded" Label="Label/Placeholder" Placeholder="DateAdded" Outlined="true" class="input" view-2-scope></IgbInput>
}
```

3. Add the code for `ListSelectionChanged` that will call the service, passing the selected FeatureId from the List:

```    c#
async void ListSelectionChanged (Features.FeaturesType feature)
{
    featuresFeaturesId = await this.featuresService
        .GetFeaturesId(feature.FeatureId.Value) 
        ?? featuresFeaturesId;

    StateHasChanged();
}
```

All Done!  You can now run the client app, and interact with the 2 views.  You should see something like this:

![](https://github.com/jberes/Feature-API-Blazor-Webinar/blob/master/Images/7-FinalApp.png?raw=true)
