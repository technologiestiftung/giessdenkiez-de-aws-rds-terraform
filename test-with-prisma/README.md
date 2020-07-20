# Test With Prisma

This is a test to introspect the database with Prisma and should not be used as working solution. We are getting the following warning from the cli:


```plain
*** WARNING ***

These models do not have a unique identifier or id and are therefore commented out.
- "trees_watered"
- "trees_watered_batch"

These fields were commented out because we currently do not support their types.
- Model "radolan_geometry", field: "centroid", original data type: "geometry"
- Model "radolan_geometry", field: "geometry", original data type: "geometry"
- Model "radolan_temp", field: "geometry", original data type: "geometry"
- Model "trees", field: "geom", original data type: "geometry"
- Model "trees_temp", field: "geom", original data type: "geometry"
```
