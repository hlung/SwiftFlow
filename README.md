# SwiftFlow
🚧 Work in progress. 🚧

## Example

### Input
```
swiftflow
  () Start
  v
  [] API Client receives responses
  v
  <> Success?
  -YES-> Handle success :: result_yes, Direction.right
  -NO-> Handle failure :: result_no

  result_yes
  v
  [] Print Yay

  result_no
  v
  [] Print Cry

  vv
  () End
  ```
  
### Output
![Output](images/output.png)
