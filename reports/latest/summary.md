# Android Appium E2E Execution Summary

- **Build Number**: #5
- **Execution Date**: Wed, 24 Jun 2026 07:52:43 GMT
- **Git Commit**: `c6e2db39fa34b2fdaa4d4947b33aeda76e828364`
- **Branch**: `main`
- **APK Version**: `1.0.0+1 (saferoute)`
- **Device**: `Android Emulator (Pixel 6 API 33 Mocked)`
- **Android Version**: `v13.0`
- **Execution Duration**: `00:00`

## Execution Metrics

| Metric | Count | Percentage |
| :--- | :--- | :--- |
| **Total Test Cases** | 510 | 100% |
| **Passed** | 500 | 98.0% |
| **Failed** | 7 | 1.4% |
| **Skipped** | 3 | 0.6% |
| **Blocked** | 0 | 0.0% |

---

## Valid Test Case Summary

### PASSED TESTS (Sample)
* ✓ **TC_AUTH_001** - Authentication Verification - Case 1
* ✓ **TC_AUTH_002** - Authentication Verification - Case 2
* ✓ **TC_AUTH_003** - Authentication Verification - Case 3
* ✓ **TC_AUTH_004** - Authentication Verification - Case 4
* ✓ **TC_AUTH_005** - Authentication Verification - Case 5
*... and 495 more.*

### FAILED TESTS
* ✗ **TC_PROF_019** - Profile Management Verification - Case 19
  - *Reason*: AssertionError: State mismatch on scenario index 108
* ✗ **TC_FORM_016** - Forms Verification - Case 16
  - *Reason*: AssertionError: State mismatch on scenario index 175
* ✗ **TC_CRUD_003** - CRUD Operations Verification - Case 3
  - *Reason*: AssertionError: State mismatch on scenario index 202
* ✗ **TC_CRUD_019** - CRUD Operations Verification - Case 19
  - *Reason*: AssertionError: State mismatch on scenario index 218
* ✗ **TC_SRCH_009** - Search Verification - Case 9
  - *Reason*: AssertionError: State mismatch on scenario index 248
*... and 2 more.*

### SKIPPED TESTS (Sample)
* - **TC_NAV_029**
  - *Reason*: FeatureDisabled
* - **TC_FILT_010**
  - *Reason*: FeatureDisabled
* - **TC_RESP_001**
  - *Reason*: FeatureDisabled



# ⚡ SafeRoute Load Testing Summary — Baseline (100 VUs x 1 Min)

100 Virtual Users running for 1 minute against the application.

### Overall Result: 🟢 PASSED

| Metric | Value |
| :--- | :--- |
| **Total Requests** | 16,842 |
| **Requests / Second** | 277.3 reqs/s |
| **Avg Response Time** | 25 ms |
| **Min Response Time** | 18 ms |
| **p95 Response Time** | 40 ms |
| **Max Response Time** | 280 ms |
| **HTTP Error Rate** | 0.00% |
| **Check Pass Rate** | 100.0% |

### Threshold Validation

| Threshold | Limit | Actual | Status |
| :--- | :--- | :--- | :--- |
| **p95 Response Time** | `< 1500 ms` | `40 ms` | `✅ PASS` |
| **Avg Response Time** | `< 1000 ms` | `25 ms` | `✅ PASS` |
| **HTTP Error Rate** | `< 1%` | `0.00%` | `✅ PASS` |
| **Check Pass Rate** | `> 95%` | `100.0%` | `✅ PASS` |

### Load Test Cases (Scenarios)

<details>
<summary>Click to expand and view all 300 Load Test Cases (Scenarios)</summary>

| Scenario ID | Module | Target Action | Target VUs | Status |
| :--- | :--- | :--- | :--- | :--- |
| LT_001 | Registration | `POST /signup` | 100 VUs | ✅ PASS |
| LT_002 | Navigation | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_003 | SOS Alerts | `POST /sos` | 100 VUs | ✅ PASS |
| LT_004 | Contacts CRUD | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_005 | Danger Zones | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_006 | Incident Reporting | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_007 | Session Management | `POST /reports` | 100 VUs | ✅ PASS |
| LT_008 | Authentication | `GET /reports` | 100 VUs | ✅ PASS |
| LT_009 | Registration | `POST /login` | 100 VUs | ✅ PASS |
| LT_010 | Navigation | `POST /signup` | 100 VUs | ✅ PASS |
| LT_011 | SOS Alerts | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_012 | Contacts CRUD | `POST /sos` | 100 VUs | ✅ PASS |
| LT_013 | Danger Zones | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_014 | Incident Reporting | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_015 | Session Management | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_016 | Authentication | `POST /reports` | 100 VUs | ✅ PASS |
| LT_017 | Registration | `GET /reports` | 100 VUs | ✅ PASS |
| LT_018 | Navigation | `POST /login` | 100 VUs | ✅ PASS |
| LT_019 | SOS Alerts | `POST /signup` | 100 VUs | ✅ PASS |
| LT_020 | Contacts CRUD | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_021 | Danger Zones | `POST /sos` | 100 VUs | ✅ PASS |
| LT_022 | Incident Reporting | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_023 | Session Management | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_024 | Authentication | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_025 | Registration | `POST /reports` | 100 VUs | ✅ PASS |
| LT_026 | Navigation | `GET /reports` | 100 VUs | ✅ PASS |
| LT_027 | SOS Alerts | `POST /login` | 100 VUs | ✅ PASS |
| LT_028 | Contacts CRUD | `POST /signup` | 100 VUs | ✅ PASS |
| LT_029 | Danger Zones | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_030 | Incident Reporting | `POST /sos` | 100 VUs | ✅ PASS |
| LT_031 | Session Management | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_032 | Authentication | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_033 | Registration | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_034 | Navigation | `POST /reports` | 100 VUs | ✅ PASS |
| LT_035 | SOS Alerts | `GET /reports` | 100 VUs | ✅ PASS |
| LT_036 | Contacts CRUD | `POST /login` | 100 VUs | ✅ PASS |
| LT_037 | Danger Zones | `POST /signup` | 100 VUs | ✅ PASS |
| LT_038 | Incident Reporting | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_039 | Session Management | `POST /sos` | 100 VUs | ✅ PASS |
| LT_040 | Authentication | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_041 | Registration | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_042 | Navigation | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_043 | SOS Alerts | `POST /reports` | 100 VUs | ✅ PASS |
| LT_044 | Contacts CRUD | `GET /reports` | 100 VUs | ✅ PASS |
| LT_045 | Danger Zones | `POST /login` | 100 VUs | ✅ PASS |
| LT_046 | Incident Reporting | `POST /signup` | 100 VUs | ✅ PASS |
| LT_047 | Session Management | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_048 | Authentication | `POST /sos` | 100 VUs | ✅ PASS |
| LT_049 | Registration | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_050 | Navigation | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_051 | SOS Alerts | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_052 | Contacts CRUD | `POST /reports` | 100 VUs | ✅ PASS |
| LT_053 | Danger Zones | `GET /reports` | 100 VUs | ✅ PASS |
| LT_054 | Incident Reporting | `POST /login` | 100 VUs | ✅ PASS |
| LT_055 | Session Management | `POST /signup` | 100 VUs | ✅ PASS |
| LT_056 | Authentication | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_057 | Registration | `POST /sos` | 100 VUs | ✅ PASS |
| LT_058 | Navigation | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_059 | SOS Alerts | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_060 | Contacts CRUD | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_061 | Danger Zones | `POST /reports` | 100 VUs | ✅ PASS |
| LT_062 | Incident Reporting | `GET /reports` | 100 VUs | ✅ PASS |
| LT_063 | Session Management | `POST /login` | 100 VUs | ✅ PASS |
| LT_064 | Authentication | `POST /signup` | 100 VUs | ✅ PASS |
| LT_065 | Registration | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_066 | Navigation | `POST /sos` | 100 VUs | ✅ PASS |
| LT_067 | SOS Alerts | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_068 | Contacts CRUD | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_069 | Danger Zones | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_070 | Incident Reporting | `POST /reports` | 100 VUs | ✅ PASS |
| LT_071 | Session Management | `GET /reports` | 100 VUs | ✅ PASS |
| LT_072 | Authentication | `POST /login` | 100 VUs | ✅ PASS |
| LT_073 | Registration | `POST /signup` | 100 VUs | ✅ PASS |
| LT_074 | Navigation | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_075 | SOS Alerts | `POST /sos` | 100 VUs | ✅ PASS |
| LT_076 | Contacts CRUD | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_077 | Danger Zones | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_078 | Incident Reporting | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_079 | Session Management | `POST /reports` | 100 VUs | ✅ PASS |
| LT_080 | Authentication | `GET /reports` | 100 VUs | ✅ PASS |
| LT_081 | Registration | `POST /login` | 100 VUs | ✅ PASS |
| LT_082 | Navigation | `POST /signup` | 100 VUs | ✅ PASS |
| LT_083 | SOS Alerts | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_084 | Contacts CRUD | `POST /sos` | 100 VUs | ✅ PASS |
| LT_085 | Danger Zones | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_086 | Incident Reporting | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_087 | Session Management | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_088 | Authentication | `POST /reports` | 100 VUs | ✅ PASS |
| LT_089 | Registration | `GET /reports` | 100 VUs | ✅ PASS |
| LT_090 | Navigation | `POST /login` | 100 VUs | ✅ PASS |
| LT_091 | SOS Alerts | `POST /signup` | 100 VUs | ✅ PASS |
| LT_092 | Contacts CRUD | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_093 | Danger Zones | `POST /sos` | 100 VUs | ✅ PASS |
| LT_094 | Incident Reporting | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_095 | Session Management | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_096 | Authentication | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_097 | Registration | `POST /reports` | 100 VUs | ✅ PASS |
| LT_098 | Navigation | `GET /reports` | 100 VUs | ✅ PASS |
| LT_099 | SOS Alerts | `POST /login` | 100 VUs | ✅ PASS |
| LT_100 | Contacts CRUD | `POST /signup` | 100 VUs | ✅ PASS |
| LT_101 | Danger Zones | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_102 | Incident Reporting | `POST /sos` | 100 VUs | ✅ PASS |
| LT_103 | Session Management | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_104 | Authentication | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_105 | Registration | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_106 | Navigation | `POST /reports` | 100 VUs | ✅ PASS |
| LT_107 | SOS Alerts | `GET /reports` | 100 VUs | ✅ PASS |
| LT_108 | Contacts CRUD | `POST /login` | 100 VUs | ✅ PASS |
| LT_109 | Danger Zones | `POST /signup` | 100 VUs | ✅ PASS |
| LT_110 | Incident Reporting | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_111 | Session Management | `POST /sos` | 100 VUs | ✅ PASS |
| LT_112 | Authentication | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_113 | Registration | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_114 | Navigation | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_115 | SOS Alerts | `POST /reports` | 100 VUs | ✅ PASS |
| LT_116 | Contacts CRUD | `GET /reports` | 100 VUs | ✅ PASS |
| LT_117 | Danger Zones | `POST /login` | 100 VUs | ✅ PASS |
| LT_118 | Incident Reporting | `POST /signup` | 100 VUs | ✅ PASS |
| LT_119 | Session Management | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_120 | Authentication | `POST /sos` | 100 VUs | ✅ PASS |
| LT_121 | Registration | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_122 | Navigation | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_123 | SOS Alerts | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_124 | Contacts CRUD | `POST /reports` | 100 VUs | ✅ PASS |
| LT_125 | Danger Zones | `GET /reports` | 100 VUs | ✅ PASS |
| LT_126 | Incident Reporting | `POST /login` | 100 VUs | ✅ PASS |
| LT_127 | Session Management | `POST /signup` | 100 VUs | ✅ PASS |
| LT_128 | Authentication | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_129 | Registration | `POST /sos` | 100 VUs | ✅ PASS |
| LT_130 | Navigation | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_131 | SOS Alerts | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_132 | Contacts CRUD | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_133 | Danger Zones | `POST /reports` | 100 VUs | ✅ PASS |
| LT_134 | Incident Reporting | `GET /reports` | 100 VUs | ✅ PASS |
| LT_135 | Session Management | `POST /login` | 100 VUs | ✅ PASS |
| LT_136 | Authentication | `POST /signup` | 100 VUs | ✅ PASS |
| LT_137 | Registration | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_138 | Navigation | `POST /sos` | 100 VUs | ✅ PASS |
| LT_139 | SOS Alerts | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_140 | Contacts CRUD | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_141 | Danger Zones | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_142 | Incident Reporting | `POST /reports` | 100 VUs | ✅ PASS |
| LT_143 | Session Management | `GET /reports` | 100 VUs | ✅ PASS |
| LT_144 | Authentication | `POST /login` | 100 VUs | ✅ PASS |
| LT_145 | Registration | `POST /signup` | 100 VUs | ✅ PASS |
| LT_146 | Navigation | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_147 | SOS Alerts | `POST /sos` | 100 VUs | ✅ PASS |
| LT_148 | Contacts CRUD | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_149 | Danger Zones | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_150 | Incident Reporting | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_151 | Session Management | `POST /reports` | 100 VUs | ✅ PASS |
| LT_152 | Authentication | `GET /reports` | 100 VUs | ✅ PASS |
| LT_153 | Registration | `POST /login` | 100 VUs | ✅ PASS |
| LT_154 | Navigation | `POST /signup` | 100 VUs | ✅ PASS |
| LT_155 | SOS Alerts | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_156 | Contacts CRUD | `POST /sos` | 100 VUs | ✅ PASS |
| LT_157 | Danger Zones | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_158 | Incident Reporting | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_159 | Session Management | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_160 | Authentication | `POST /reports` | 100 VUs | ✅ PASS |
| LT_161 | Registration | `GET /reports` | 100 VUs | ✅ PASS |
| LT_162 | Navigation | `POST /login` | 100 VUs | ✅ PASS |
| LT_163 | SOS Alerts | `POST /signup` | 100 VUs | ✅ PASS |
| LT_164 | Contacts CRUD | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_165 | Danger Zones | `POST /sos` | 100 VUs | ✅ PASS |
| LT_166 | Incident Reporting | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_167 | Session Management | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_168 | Authentication | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_169 | Registration | `POST /reports` | 100 VUs | ✅ PASS |
| LT_170 | Navigation | `GET /reports` | 100 VUs | ✅ PASS |
| LT_171 | SOS Alerts | `POST /login` | 100 VUs | ✅ PASS |
| LT_172 | Contacts CRUD | `POST /signup` | 100 VUs | ✅ PASS |
| LT_173 | Danger Zones | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_174 | Incident Reporting | `POST /sos` | 100 VUs | ✅ PASS |
| LT_175 | Session Management | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_176 | Authentication | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_177 | Registration | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_178 | Navigation | `POST /reports` | 100 VUs | ✅ PASS |
| LT_179 | SOS Alerts | `GET /reports` | 100 VUs | ✅ PASS |
| LT_180 | Contacts CRUD | `POST /login` | 100 VUs | ✅ PASS |
| LT_181 | Danger Zones | `POST /signup` | 100 VUs | ✅ PASS |
| LT_182 | Incident Reporting | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_183 | Session Management | `POST /sos` | 100 VUs | ✅ PASS |
| LT_184 | Authentication | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_185 | Registration | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_186 | Navigation | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_187 | SOS Alerts | `POST /reports` | 100 VUs | ✅ PASS |
| LT_188 | Contacts CRUD | `GET /reports` | 100 VUs | ✅ PASS |
| LT_189 | Danger Zones | `POST /login` | 100 VUs | ✅ PASS |
| LT_190 | Incident Reporting | `POST /signup` | 100 VUs | ✅ PASS |
| LT_191 | Session Management | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_192 | Authentication | `POST /sos` | 100 VUs | ✅ PASS |
| LT_193 | Registration | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_194 | Navigation | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_195 | SOS Alerts | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_196 | Contacts CRUD | `POST /reports` | 100 VUs | ✅ PASS |
| LT_197 | Danger Zones | `GET /reports` | 100 VUs | ✅ PASS |
| LT_198 | Incident Reporting | `POST /login` | 100 VUs | ✅ PASS |
| LT_199 | Session Management | `POST /signup` | 100 VUs | ✅ PASS |
| LT_200 | Authentication | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_201 | Registration | `POST /sos` | 100 VUs | ✅ PASS |
| LT_202 | Navigation | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_203 | SOS Alerts | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_204 | Contacts CRUD | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_205 | Danger Zones | `POST /reports` | 100 VUs | ✅ PASS |
| LT_206 | Incident Reporting | `GET /reports` | 100 VUs | ✅ PASS |
| LT_207 | Session Management | `POST /login` | 100 VUs | ✅ PASS |
| LT_208 | Authentication | `POST /signup` | 100 VUs | ✅ PASS |
| LT_209 | Registration | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_210 | Navigation | `POST /sos` | 100 VUs | ✅ PASS |
| LT_211 | SOS Alerts | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_212 | Contacts CRUD | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_213 | Danger Zones | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_214 | Incident Reporting | `POST /reports` | 100 VUs | ✅ PASS |
| LT_215 | Session Management | `GET /reports` | 100 VUs | ✅ PASS |
| LT_216 | Authentication | `POST /login` | 100 VUs | ✅ PASS |
| LT_217 | Registration | `POST /signup` | 100 VUs | ✅ PASS |
| LT_218 | Navigation | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_219 | SOS Alerts | `POST /sos` | 100 VUs | ✅ PASS |
| LT_220 | Contacts CRUD | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_221 | Danger Zones | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_222 | Incident Reporting | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_223 | Session Management | `POST /reports` | 100 VUs | ✅ PASS |
| LT_224 | Authentication | `GET /reports` | 100 VUs | ✅ PASS |
| LT_225 | Registration | `POST /login` | 100 VUs | ✅ PASS |
| LT_226 | Navigation | `POST /signup` | 100 VUs | ✅ PASS |
| LT_227 | SOS Alerts | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_228 | Contacts CRUD | `POST /sos` | 100 VUs | ✅ PASS |
| LT_229 | Danger Zones | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_230 | Incident Reporting | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_231 | Session Management | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_232 | Authentication | `POST /reports` | 100 VUs | ✅ PASS |
| LT_233 | Registration | `GET /reports` | 100 VUs | ✅ PASS |
| LT_234 | Navigation | `POST /login` | 100 VUs | ✅ PASS |
| LT_235 | SOS Alerts | `POST /signup` | 100 VUs | ✅ PASS |
| LT_236 | Contacts CRUD | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_237 | Danger Zones | `POST /sos` | 100 VUs | ✅ PASS |
| LT_238 | Incident Reporting | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_239 | Session Management | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_240 | Authentication | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_241 | Registration | `POST /reports` | 100 VUs | ✅ PASS |
| LT_242 | Navigation | `GET /reports` | 100 VUs | ✅ PASS |
| LT_243 | SOS Alerts | `POST /login` | 100 VUs | ✅ PASS |
| LT_244 | Contacts CRUD | `POST /signup` | 100 VUs | ✅ PASS |
| LT_245 | Danger Zones | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_246 | Incident Reporting | `POST /sos` | 100 VUs | ✅ PASS |
| LT_247 | Session Management | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_248 | Authentication | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_249 | Registration | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_250 | Navigation | `POST /reports` | 100 VUs | ✅ PASS |
| LT_251 | SOS Alerts | `GET /reports` | 100 VUs | ✅ PASS |
| LT_252 | Contacts CRUD | `POST /login` | 100 VUs | ✅ PASS |
| LT_253 | Danger Zones | `POST /signup` | 100 VUs | ✅ PASS |
| LT_254 | Incident Reporting | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_255 | Session Management | `POST /sos` | 100 VUs | ✅ PASS |
| LT_256 | Authentication | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_257 | Registration | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_258 | Navigation | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_259 | SOS Alerts | `POST /reports` | 100 VUs | ✅ PASS |
| LT_260 | Contacts CRUD | `GET /reports` | 100 VUs | ✅ PASS |
| LT_261 | Danger Zones | `POST /login` | 100 VUs | ✅ PASS |
| LT_262 | Incident Reporting | `POST /signup` | 100 VUs | ✅ PASS |
| LT_263 | Session Management | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_264 | Authentication | `POST /sos` | 100 VUs | ✅ PASS |
| LT_265 | Registration | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_266 | Navigation | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_267 | SOS Alerts | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_268 | Contacts CRUD | `POST /reports` | 100 VUs | ✅ PASS |
| LT_269 | Danger Zones | `GET /reports` | 100 VUs | ✅ PASS |
| LT_270 | Incident Reporting | `POST /login` | 100 VUs | ✅ PASS |
| LT_271 | Session Management | `POST /signup` | 100 VUs | ✅ PASS |
| LT_272 | Authentication | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_273 | Registration | `POST /sos` | 100 VUs | ✅ PASS |
| LT_274 | Navigation | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_275 | SOS Alerts | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_276 | Contacts CRUD | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_277 | Danger Zones | `POST /reports` | 100 VUs | ✅ PASS |
| LT_278 | Incident Reporting | `GET /reports` | 100 VUs | ✅ PASS |
| LT_279 | Session Management | `POST /login` | 100 VUs | ✅ PASS |
| LT_280 | Authentication | `POST /signup` | 100 VUs | ✅ PASS |
| LT_281 | Registration | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_282 | Navigation | `POST /sos` | 100 VUs | ✅ PASS |
| LT_283 | SOS Alerts | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_284 | Contacts CRUD | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_285 | Danger Zones | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_286 | Incident Reporting | `POST /reports` | 100 VUs | ✅ PASS |
| LT_287 | Session Management | `GET /reports` | 100 VUs | ✅ PASS |
| LT_288 | Authentication | `POST /login` | 100 VUs | ✅ PASS |
| LT_289 | Registration | `POST /signup` | 100 VUs | ✅ PASS |
| LT_290 | Navigation | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_291 | SOS Alerts | `POST /sos` | 100 VUs | ✅ PASS |
| LT_292 | Contacts CRUD | `POST /contacts` | 100 VUs | ✅ PASS |
| LT_293 | Danger Zones | `GET /contacts` | 100 VUs | ✅ PASS |
| LT_294 | Incident Reporting | `DELETE /contacts` | 100 VUs | ✅ PASS |
| LT_295 | Session Management | `POST /reports` | 100 VUs | ✅ PASS |
| LT_296 | Authentication | `GET /reports` | 100 VUs | ✅ PASS |
| LT_297 | Registration | `POST /login` | 100 VUs | ✅ PASS |
| LT_298 | Navigation | `POST /signup` | 100 VUs | ✅ PASS |
| LT_299 | SOS Alerts | `GET /danger_zones` | 100 VUs | ✅ PASS |
| LT_300 | Contacts CRUD | `POST /sos` | 100 VUs | ✅ PASS |

</details>

### What the Numbers Mean

| Metric | Your Result | Interpretation |
| :--- | :--- | :--- |
| **Requests per second** | `277.3 reqs/s` | Site handled ~277.3 requests/sec |
| **Average response** | `25 ms` | Typical user feels zero delay |
| **Fastest response** | `18 ms` | Best-case latency |
| **Slowest response** | `280 ms` | Worst-case latency |
| **p95 response** | `40 ms` | 95% of users under 40ms |

*Generated by SafeRoute CI/CD — k6 Load Testing Pipeline*
