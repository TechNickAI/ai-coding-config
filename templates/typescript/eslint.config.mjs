import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";

const eslintConfig = defineConfig([
    // Global ignores must come FIRST to ensure files are ignored before other rules are evaluated
    globalIgnores([
        // Default ignores from Next.js:
        ".next/**",
        "out/**",
        "build/**",
        "next-env.d.ts",
        // Additional project-specific ignores:
        "coverage/**",
        "node_modules/**",
        "dist/**",
        ".prisma/**",
        "**/*.config.ts",
        "**/*.config.mjs",
        "**/*.config.js",
    ]),
    ...nextVitals,
    ...nextTs,
    {
        rules: {
            // Custom rules
            "@typescript-eslint/no-unused-vars": [
                "warn",
                {
                    argsIgnorePattern: "^_",
                    varsIgnorePattern: "^_",
                },
            ],
            "@typescript-eslint/no-explicit-any": "warn",
            "react/no-unescaped-entities": "off",
        },
    },
    // Relax rules for test files
    {
        files: [
            "**/__tests__/**",
            "**/*.test.ts",
            "**/*.test.tsx",
            "**/*.spec.ts",
            "**/*.spec.tsx",
        ],
        rules: {
            "@typescript-eslint/no-explicit-any": "off",
            "@next/next/no-img-element": "off",
        },
    },
]);

export default eslintConfig;
