import os
import sys

def main():
    try:
        from pypdf import PdfReader
    except ImportError:
        os.system(f"{sys.executable} -m pip install pypdf")
        from pypdf import PdfReader

    pdf_path = r"e:\innovista\app2\Google Antigravity Hackathon - Challenges.pdf"
    reader = PdfReader(pdf_path)
    text = ""
    for i, page in enumerate(reader.pages):
        text += f"\n\n---PAGE {i+1}---\n\n"
        text += page.extract_text()
        
    with open(r"e:\innovista\app2\extracted_pdf.txt", "w", encoding="utf-8") as f:
        f.write(text)

if __name__ == "__main__":
    main()
