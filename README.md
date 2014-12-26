## Onion (`v0.0`)

### Usage

```
git clone
npm install
coffee WriteTemplate.coffee configuration.json
```

### Configuration File Format

```json
{
  "input" : "something.js",
  "output" : "something.json",

  "properties" : {
    "one" : "1",
    "two" : "2"
  }
}
```