function setupAiProductDescription() {
  const button = document.querySelector("[data-ai-description-button]");
  if (!button) return;

  const url = button.dataset.url;
  const promptFieldId = button.dataset.promptFieldId;
  const descriptionFieldId = button.dataset.descriptionFieldId;

  const promptField = document.getElementById(promptFieldId);
  const descriptionField = document.getElementById(descriptionFieldId);
  const statusEl = document.querySelector("[data-ai-description-status]");

  if (!promptField || !descriptionField) return;

  const csrfMeta = document.querySelector("meta[name='csrf-token']");
  const csrfToken = csrfMeta && csrfMeta.getAttribute("content");

  button.addEventListener("click", async () => {
    const prompt = promptField.value.trim();
    if (!prompt) {
      if (statusEl) statusEl.textContent = button.dataset.blankPromptMessage || "";
      return;
    }

    button.disabled = true;
    if (statusEl) statusEl.textContent = button.dataset.loadingMessage || "Generating...";

    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": csrfToken || ""
        },
        body: JSON.stringify({ prompt: prompt })
      });

      const json = await response.json();

      if (!response.ok || json.error) {
        if (statusEl) statusEl.textContent = json.error || (button.dataset.errorMessage || "Error");
        return;
      }

      descriptionField.value = json.description;
      if (statusEl) statusEl.textContent = button.dataset.successMessage || "Description updated";
    } catch (e) {
      if (statusEl) statusEl.textContent = button.dataset.errorMessage || "Error";
      console.error(e);
    } finally {
      button.disabled = false;
    }
  });
}

document.addEventListener("turbo:load", setupAiProductDescription);
document.addEventListener("DOMContentLoaded", setupAiProductDescription);
