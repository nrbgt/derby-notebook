#/bin/bash
grep -rFl \
    "model.root.ref(model._at + '.' + key, segments.join('.'));" \
    node_modules \
  | xargs sed -i \
    's/\(.*model.root.ref.*segments.*\)).*/\1, {updateIndices: true});/g'
