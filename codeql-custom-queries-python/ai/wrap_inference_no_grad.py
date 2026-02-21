import torch
import torch.nn as nn

class ImageClassifier(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv = nn.Conv2d(3, 16, 3)
        self.fc = nn.Linear(16, 10)

    def forward(self, x):
        return self.fc(self.conv(x).flatten(1))


def evaluate_bad(model, dataloader):
    """Non compliant : pas de torch.no_grad() pendant l'inférence."""
    model.eval()
    results = []
    for inputs in dataloader:
        outputs = model(inputs)  # $ Alert
        results.append(outputs)
    return results


def evaluate_good(model, dataloader):
    """Compliant : inférence enveloppée dans torch.no_grad()."""
    model.eval()
    results = []
    with torch.no_grad():
        for inputs in dataloader:
            outputs = model(inputs)  # pas d'alerte
            results.append(outputs)
    return results


def evaluate_mixed(model, dataloader):
    """Non compliant : un appel hors no_grad malgré un eval()."""
    model.eval()
    first_output = model(dataloader[0])  # $ Alert

    with torch.no_grad():
        second_output = model(dataloader[1])  # pas d'alerte

    return first_output, second_output