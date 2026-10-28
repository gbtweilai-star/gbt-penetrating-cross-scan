# penetrating_cross_scan

**One capability bit from GBT V8, packaged standalone.** No. 224 of 341,
`security` domain (Security).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 穿透式交叉扫描引擎（增强版）：触手到位**必须**调用钩子（未触发=失败）· 步骤锁（跳步当场拒）· 每单元 ≥2 路独立读交叉互扫（不一致→第三路仲裁）· 遗漏检测（覆盖率<100% 有界补扫）· 全程留痕 source_kind=cross_scan；三种目标 bindings/registry/tree:<目录>

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-penetrating-cross-scan.git
cd gbt-penetrating-cross-scan
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_penetrating_cross_scan info                  # capability card
python -m gbt_penetrating_cross_scan spec --json           # machine-readable contract
python -m gbt_penetrating_cross_scan check --payload '{}'
python -m gbt_penetrating_cross_scan run   --payload '{}'
```

Real `info` output from this machine:

```text
penetrating_cross_scan  (security)  v1.0.0
----------------------------------------
穿透式交叉扫描引擎（增强版）：触手到位**必须**调用钩子（未触发=失败）· 步骤锁（跳步当场拒）· 每单元 ≥2 路独立读交叉互扫（不一致→第三路仲裁）· 遗漏检测（覆盖率<100% 有界补扫）· 全程留痕 source_kind=cross_scan；三种目标 bindings/registry/tree:<目录>

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : bindings, registry, tree
```

Wire a real implementation:

```python
from gbt_penetrating_cross_scan import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`bindings`、`registry`、`tree`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.13s
```

## Provenance

| field | value |
|---|---|
| capability | `penetrating_cross_scan` |
| domain | `security` |
| handler | `penetrating_cross_scan` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [security/penetrating_cross_scan](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/security/penetrating_cross_scan.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
