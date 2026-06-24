import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  scenarios: {
    api_load: {
      executor: 'constant-vus',
      vus: 10,
      duration: '10s',
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<1500', 'avg<1000'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  const baseUrl = 'https://web-production-0324de.up.railway.app';
  
  // 1. Fetch Danger Zones
  const resZones = http.get(`${baseUrl}/danger_zones`);
  check(resZones, {
    'danger zones status is 200': (r) => r.status === 200,
  });
  sleep(0.5);

  // 2. Fetch Incident Reports
  const resReports = http.get(`${baseUrl}/reports`);
  check(resReports, {
    'reports status is 200': (r) => r.status === 200,
  });
  sleep(0.5);
}
