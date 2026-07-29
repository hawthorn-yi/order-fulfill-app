# Lessons Learned — 避免重复 Bug

## 1. apply_patch 必须用 `-` + `+` 配对，不能用空格 + `+`

空格前缀行 = 保留原行，`-` = 删除，`+` = 新增。
用空格 + `+` 会产生重复行（如 double const rows → SyntaxError）。
修改已有行时，始终用 `-` + `+` 配对。

## 2. 函数体引用新参数时，同步修改函数签名

`function renderKPIs()` 体用了 `orders` 但签名没声明 → ReferenceError。
修改函数体时检查签名是否匹配。

## 3. JS 字符串中的中文引号必须是 Unicode 全角引号

ASCII 双引号 (U+0022) 会提前闭合 JS 字符串 → SyntaxError。
使用 Unicode 全角引号 `\u201C` `\u201D`。

## 4. 修改内嵌 JS 后必须 `node --check`

提取 JS → 加 mock → `node --check` 验证后才能确认无语法错误。