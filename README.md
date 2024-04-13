![Robot Serving](images/root-serving.webp)

# PoC: AI generated Terraform Planning and Validation

This is a quick PoC made to test the idea of "Can AI generate Terraform templates?"

# IMPORTANT

This is a PoC, and it's not meant to be used in production or any serious use and it just serves to test the idea of using LLMs to generate IaC (Infrastructure as code) plans. 

## Background

It's made really clear by now that LLMs like GPT4 are decent in writing some code, but Terraform applied to AWS requires a little bit more depth and intersection of different skills and knowledge. For me TF is an extremely abstract way of representing (Planning) a very complex environment, and I wanted to test this idea of how LLM would score in actually planning an AWS deployment.

## What this program does

- From a language description of the infrastructure (instructions.txt), this program will use GPT-4 to generate a main.tf file that will < attempt > to replicate the instructions.
- This works in 2 steps:
    - Make GPT4 generate the first main.tf file,
    - Validate its content, syntax, alignment with the original language instructions again with GPT4,
    - "If" everything is okay (Re-validation by GPT4 itself again), then write the main.tf to an actual file,
    - Validate the main.tf written in} `./output/` folder (Which name is specified as an argument of the program) with `Terraform validate` and just display the output to stdout.

## How it does it

- LLM: OpenAI GPT-4
- Terraform: 1.8.0

## Iterative method:

- First OpenAI GPT4 will interpret the language instructions given, and will generate an HCL terraform-valid syntax output.
- Then, another iteration of OpenAI GPT4 will validate the syntax of the output HCL file with Terraform and "test" this output by comparing the results with the original instructions (Basically, "Is this HCL Terraform valid? according to this instructions?").
- It will iterate until the output is "correct" or until the iteration limit is exhausted (As specified in the main script. Originally I left 2 iterations, which maybe would work with more but it can get a little bit expensive just for a PoC).

# Conclusions

- 50% of the time it got the answer correct which is way more than what I expected at first.
- It needs more testing, since the instructions, while comprehensive (At least considering it's just a PoC), do not specify SSH keys (This was the thing that tripped GPT the most) or other details that are important for Terraform.
- Of course, it's only a matter of time when there's something in the industry that does this.

Here's what [perplexity.ai](https://perplexity.ai/) has to say about this:

1. AI progress is driven by advancements in compute power, data availability, and algorithms. As these inputs continue to improve exponentially, AI capabilities are likely to keep growing at a rapid pace in the near future.[^6^][^11^]
2. There is a pattern of AI systems quickly surpassing human-level performance in various domains shortly after their initial release, even if the early versions had limitations. For example, GPT-3.5 scored in the bottom 10% on a law exam, but GPT-4 released just months later scored in the top 10%.[^11^]
3. Experts predict continued rapid progress in AI. Google's chief scientist estimates a 50% chance of "human-level" AI within 2-3 years. OpenAI's CEO believes artificial general intelligence (AGI) could be reached in the next 4-5 years.[^11^]
4. Machine learning models have the ability to continuously learn and improve their accuracy as they are exposed to more data over time, without needing to be explicitly re-programmed.[^4^][^8^] This allows for rapid iterative improvement.
5. There are many examples of AI quickly improving on initial poor performance to reach remarkable levels. IBM's Deep Blue beat the world chess champion in 1997 after earlier losses.[^2^] Image and speech recognition went from inaccurate to superhuman in a short timespan.[^11^]

So in summary, your mental model that basic AI capabilities tend to improve and reach impressive levels very quickly appears to match the overall arc of AI progress to date. The rapid exponential improvement in AI's key inputs, its ability to learn, and the many prior examples of fast progress from poor initial performance to superhuman levels all support the idea that today's nascent AI abilities are likely to get "way better soon". The search results indicate this is a common dynamic in the AI field.

Citations:
[^1^]: [source](https://alltechmagazine.com/the-evolution-of-ai/?amp=1)
[^2^]: [source](https://redresscompliance.com/the-evolution-of-ai-tracing-its-roots-and-milestones/)
[^3^]: [source](https://ourworldindata.org/brief-history-of-ai)
[^4^]: [source](https://squarkai.com/how-machine-learning-models-improve-over-time/)
[^5^]: [source](https://viso.ai/deep-learning/ml-ai-models/)
[^6^]: [source](https://time.com/6300942/ai-progress-charts/)
[^7^]: [source](https://ai100.stanford.edu/gathering-strength-gathering-storms-one-hundred-year-study-artificial-intelligence-ai100-2021-1/sq2)
[^8^]: [source](https://neptune.ai/blog/improving-ml-model-performance)
[^9^]: [source](https://www.snowflake.com/guides/ai-models-what-they-are-and-how-they-work/)
[^10^]: [source](https://academic.oup.com/jcmc/article/28/1/zmac029/6827859)
[^11^]: [source](https://time.com/6556168/when-ai-outsmart-humans/)
[^12^]: [source](https://digital-transformation.hee.nhs.uk/binaries/content/assets/digital-transformation/dart-ed/understandingconfidenceinai-may22.pdf)
[^13^]: [source](https://www.pewresearch.org/internet/2021/06/16/1-worries-about-developments-in-ai/)
[^14^]: [source](https://www.algolia.com/blog/ai/how-continuous-learning-lets-machine-learning-provide-increasingly-accurate-predictions-and-recommendations/)
[^15^]: [source](https://www.ultimate.ai/blog/ai-automation/what-is-a-feedback-loop)
[^16^]: [source](https://eng.vt.edu/magazine/stories/fall-2023/ai.html)
[^17^]: [source](https://www.techtarget.com/searchenterpriseai/definition/machine-learning-ML)
[^18^]: [source](https://www.imf.org/-/media/Files/Publications/SDN/2024/English/SDNEA2024001.ashx)
[^19^]: [source](https://www.mdpi.com/2076-3417/13/12/7082)
[^20^]: [source](https://www.gao.gov/blog/artificial-intelligences-use-and-rapid-growth-highlight-its-possibilities-and-perils)[0m


