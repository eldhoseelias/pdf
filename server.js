const express = require('express');
const puppeteer = require('puppeteer');

const app = express();

app.get('/pdf', async (req, res) => {
    console.log('Taking screenshot');
    console.info(process.env.CHROME_BIN,'process.env.CHROME_BIN')
    const browser = await puppeteer.launch({
        headless: "new",
        executablePath: '/usr/bin/google-chrome',
        args: ['--no-sandbox', '--headless', '--disable-gpu','--disable-setuid-sandbox']
      });
    const page = await browser.newPage();
    await page.evaluate(`(async() => {
        console.log('1');
     })()`);
    const html = `<!DOCTYPE html>
    <html>
    <body>
    
    <h1>My First Heading 1</h1>
    
    <p>My first paragraph.</p>
    
    </body>
    </html>
    
    `;
    await page.setContent(html,{waitUntil:'domcontentloaded'});
    const pdfOptions = { format: 'a4', printBackground: true};
    const pdfBuffer = await page.pdf(pdfOptions);

    await browser.close();

    res.set('Content-Type', 'application/pdf'); 
    res.send(pdfBuffer);
    console.log('Screenshot taken');
});

app.listen(3000, () => {
    console.log('Listening on port 3000');
});
