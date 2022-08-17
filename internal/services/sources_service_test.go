package services

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	_ "github.com/RHEnVision/provisioning-backend/internal/testing/initialization"

	"github.com/RHEnVision/provisioning-backend/internal/clients/sources"
	clientStub "github.com/RHEnVision/provisioning-backend/internal/clients/sources/stubs"
	"github.com/RHEnVision/provisioning-backend/internal/dao/stubs"
	"github.com/RHEnVision/provisioning-backend/internal/testing/identity"
	"github.com/stretchr/testify/assert"
)

func TestListSourcesHandler(t *testing.T) {
	ctx := stubs.WithAccountDaoOne(context.Background())
	ctx = identity.WithTenant(t, ctx)
	ctx = clientStub.WithSourcesClient(ctx)

	req, err := http.NewRequestWithContext(ctx, "GET", "/api/provisioning/sources", nil)
	assert.Nil(t, err, fmt.Sprintf("Error creating a new request: %v", err))

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(ListSources)
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("Handler returned wrong status code. Expected: %d. Got: %d.", http.StatusOK, status)
	}

	var result []sources.Source

	if err := json.NewDecoder(rr.Body).Decode(&result); err != nil {
		t.Errorf("Error decoding response body: %v", err)
	}

	assert.Equal(t, 2, len(result), "expected two result in response json")
}
